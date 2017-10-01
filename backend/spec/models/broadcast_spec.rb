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
end
