
# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Broadcast, type: :model do
  subject { broadcast }

  let(:broadcast) { build(:broadcast) }
  describe '#title' do
    describe 'title nil' do
      let(:broadcast) { build(:broadcast, title: nil) }
      it { is_expected.not_to be_valid }
    end

    describe 'empty title' do
      let(:broadcast) { build(:broadcast, title: '  ') }
      it { is_expected.not_to be_valid }
    end

    describe 'normalize' do
      it 'strips excessive whitespace' do
        broadcast.title = 'Neo   Magazin  Royale '
        broadcast.save
        expect(broadcast.title).to eq 'Neo Magazin Royale'
      end
    end

    describe 'duplicates' do
      it_behaves_like 'database unique attribute', :broadcast, title: 'XYZ'

      describe 'are case insensitive' do
        let(:broadcast) { create(:broadcast, title: 'Tagesschau') }
        let(:duplicate) { build(:broadcast, title: 'tagesschau') }
        before { broadcast }
        subject { duplicate }

        it { is_expected.not_to be_valid }
        it 'raises a database exception' do
          expect { duplicate.save(validate: false) }.to raise_exception(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end

  describe '#broadcast_id' do
    it_behaves_like 'database unique attribute', :broadcast, mediathek_identification: 123
    describe 'can be nil' do
      subject { build(:broadcast, mediathek_identification: nil) }
      it { is_expected.to be_valid }
    end
  end

  describe '#aliased_inner_join' do
    let(:the_alias) { :aliased_join_table }

    let(:relation) { described_class.aliased_inner_join(the_alias, association) }

    context 'on Schedule' do
      let(:association) { Schedule }
      let(:broadcast) { create(:broadcast, title: 'ABCD', stations: create_list(:station, 1, id: 1)) }
      before { broadcast }

      describe 'is chainable' do
        let(:first_chain) { relation.where('"aliased_join_table"."station_id" = 1') }
        subject { first_chain }
        it { is_expected.to eq [broadcast] }

        describe 'and can be chained on' do
          describe '#full_search' do
            subject { first_chain.full_search('ABCD') }
            it { is_expected.to eq [broadcast] }
          end

          describe '#unevaluated' do
            let(:user) { create(:user) }
            subject { first_chain.unevaluated(user) }
            it { is_expected.to eq [broadcast] }
          end
        end
      end
    end
  end

  describe '#full_search' do
    before do
      create_list(:broadcast, 10)
    end

    let(:station) { create(:station, name: 'Das Erste') }

    let(:searched_broadcast) do
      create(:broadcast, title: 'It\s me!',
                         description: 'This is the best broadcast ever',
                         stations: [station])
    end

    describe 'retrieves broadcasts with a similar title' do
      subject { described_class.full_search 'Me' }
      it { is_expected.to include(searched_broadcast) }
    end

    describe 'retrieves broadcasts with a similar descripton' do
      subject { described_class.full_search 'best' }
      it { is_expected.to include(searched_broadcast) }
    end

    describe 'retrieves broadcasts with a similar station name' do
      subject { described_class.full_search 'Das Erste' }
      it { is_expected.to include(searched_broadcast) }
    end

    describe 'retrieves broadcasts with a similar station name regardless a typo' do
      subject { described_class.full_search 'Das Erte' }
      it { is_expected.to include(searched_broadcast) }
    end
  end

  describe '#search' do
    before do
      create_list(:broadcast, 2)
    end

    let(:station) { create(:station, name: 'Das Erste') }

    let(:medium) { create(:medium, name: 'WebTV') }

    let!(:searched_broadcast) do
      create(:broadcast, title: 'A Mickey Mouse Film',
                         description: 'This is the best broadcast ever',
                         medium: medium,
                         stations: [station])
    end

    context 'default search' do
      subject { described_class.search.length }
      it { is_expected.to eq(described_class.count) }
    end

    context 'search by title' do
      subject { described_class.search(query: 'Film') }
      it { is_expected.to include(searched_broadcast) }
    end

    context 'filter by medium' do
      subject { described_class.search(filter_params: { medium: medium }) }
      it { is_expected.to include(searched_broadcast) }
    end

    context 'filter by station' do
      subject { described_class.search(filter_params: { station: station }) }
      it { is_expected.to include(searched_broadcast) }
    end

    describe 'filter by station' do
      let(:relation) { described_class.search(filter_params: { station: station }) }
      describe 'along with random order' do
        let(:relation) { super().results_order('random', seed: 0.123456789) }
        context 'the result set includes one broadcast with a lot of stations and many impressions' do
          before do
            # that's the trouble maker
            lot_of_stations = create_list(:station, 3) + [station]
            troublemaker = create(:broadcast, medium: medium, stations: lot_of_stations)
            create_list(:impression, 23, broadcast: troublemaker)

            # now create some more broadcasts matching the query
            create_list(:broadcast, 8, stations: [station])
            # now we have the searched_broadcast + troublemaker + noise
            # totalling 10 broadcasts
          end

          describe 'size of entire result set' do
            subject { relation.count }
            it { is_expected.to eq(10) }
          end

          describe 'size of paginated result set' do
            subject { relation.page(1).per(6).count }
            it { is_expected.to eq(6) }
          end
        end
      end
    end

    context 'sort by alphabetical order' do
      before do
        create(:broadcast, title: 'Popeye Film')
        create(:broadcast, title: 'Tom und Jerry Film')
      end

      it 'sorts by title ascending' do
        expect(described_class.search(query: 'Film', sort: 'asc').first.title).to eq(searched_broadcast.title)
      end

      it 'sorts by title descending' do
        expect(described_class.search(query: 'Film', sort: 'desc').last.title).to eq(searched_broadcast.title)
      end
    end
  end

  describe '#results_order' do
    let(:broadcasts) { create_list(:broadcast, 13) }
    before { broadcasts }

    describe 'random' do
      let(:relation) { described_class.results_order('random', seed: seed) }
      context 'different seeds' do
        let(:seed) { '123412341234' }
      end

      describe 'paginates' do
        let(:seed) { 0.12341234 }

        describe 'for two seeds' do
          subject { relation.page(1).per(6).map(&:id) }
          let(:compared_with) { described_class.results_order('random', seed: other_seed).page(1).per(6).map(&:id) } # same relation again

          context 'which are the same' do
            let(:other_seed) { seed }
            it { is_expected.to eq(compared_with) }
          end

          context 'which are different' do
            let(:other_seed) { 0.987654321 }
            it { is_expected.not_to eq(compared_with) }
          end
        end

        context 'for same seed' do
          describe 'repeated pagination' do
            let(:result_set) do
              result_set = []
              result_set += described_class.results_order('random', seed: seed).page(1).per(6)
              result_set += described_class.results_order('random', seed: seed).page(2).per(6)
              result_set += described_class.results_order('random', seed: seed).page(3).per(6)
              result_set
            end

            describe 'result set' do
              subject { result_set.map(&:id) }
              it 'includes all broadcasts' do
                is_expected.to match_array(broadcasts.map(&:id).uniq)
              end

              it 'contains no duplicates' do
                is_expected.to eq(subject.uniq)
              end
            end
          end
        end
      end
    end
  end

  describe '#valid?' do
    subject { broadcast }
    let(:broadcast) { build(:broadcast, attributes) }
    describe 'empty description' do
      let(:attributes) { { description: '' } }
      it { is_expected.not_to be_valid }
    end

    describe 'no description' do
      let(:attributes) { { description: nil } }
      it { is_expected.not_to be_valid }
      describe 'error message' do
        before { broadcast.save }
        subject { broadcast.errors.full_messages }
        it { is_expected.to include('Beschreibung muss ausgefüllt werden') }
      end
    end

    describe 'too short description' do
      let(:attributes) { { description: 'WTF, too short' } }
      it { is_expected.not_to be_valid }
    end

    describe 'description contains URL' do
      let(:description) { ('a' * 100) + 'http://alternativlos.org/' }
      let(:attributes) { { description: description } }
      it { is_expected.not_to be_valid }

      describe 'just a colon' do
        let(:description) { 'Im Babo-Bus fahren ... und bestehen gemeinsam brisante Aufgaben: wer hat z.B. ...?' }
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#destroy' do
    let(:broadcast) { create(:broadcast) }
    before do
      create(:impression, id: 1, broadcast: broadcast)
      create(:impression, id: 2, broadcast: broadcast)
      create(:impression, id: 3)
    end

    it 'destroys associated impressions only' do
      expect { broadcast.destroy }.to(change { Impression.count }.from(3).to(1))
      expect(Impression.first.id).to eq 3
    end
  end

  describe '#medium' do
    subject { build(:broadcast, medium: medium) }

    context 'missing' do
      let(:medium) { nil }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#image_url' do
    describe 'image_url can be nil' do
      let(:broadcast) { build(:broadcast, image_url: nil) }
      it { is_expected.to be_valid }
    end

    describe 'empty image_url' do
      let(:broadcast) { build(:broadcast, image_url: ' ') }
      it { is_expected.to_not be_valid }
    end

    describe 'image_url' do
      let(:broadcast) { build(:broadcast, image_url: 'https://www.zdf.de/assets/teamfoto-102~768x432') }
      it { is_expected.to be_valid }
    end

    describe 'invalid image url' do
      let(:broadcast) { build(:broadcast, image_url: 'htps:/www.zdf.de/assets/teamfoto-102~768x432') }
      it { is_expected.to_not be_valid }
    end
  end

  describe '#broadcast_url' do
    describe 'nil broadcast_url' do
      let(:broadcast) { build(:broadcast, broadcast_url: nil) }
      it { is_expected.to be_valid }
    end

    describe 'empty broadcast_url' do
      let(:broadcast) { build(:broadcast, broadcast_url: ' ') }
      it { is_expected.to_not be_valid }
    end

    describe 'broadcast_url' do
      let(:broadcast) { build(:broadcast, broadcast_url: 'https://www.zdf.de/filme/ein-starkes-team/wespennest-118.html') }
      it { is_expected.to be_valid }
    end

    describe 'invalid broadcast_url' do
      let(:broadcast) { build(:broadcast, broadcast_url: 'htps:/www.zdf.de/filme/ein-starkes-team/wespennest-118.html') }
      it { is_expected.to_not be_valid }
    end
  end
end
