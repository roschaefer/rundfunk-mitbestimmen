require 'rails_helper'
RSpec.describe 'Statistic::Station', type: :request do
  let(:headers) { {} }

  context 'no stations at all' do
    describe 'GET' do
      describe '/statistic/stations' do
        let(:url) { '/statistic/stations' }
        before { get url, headers: headers }
        subject { response }
        it { is_expected.to have_http_status(:ok) }
        describe 'response data' do
          subject { parse_json(response.body, 'data') }
          it { is_expected.to eq []}
        end
      end
    end
  end

  context 'broadcast without impressions' do
    describe 'GET' do
      describe '/statistic/stations' do
        let(:url) { '/statistic/stations' }
        subject { parse_json(response.body, 'data/0/attributes/') }
        before do
          medium = create(:medium, id: 1)
          stations = create_list(:station, 1, id: 4, medium: medium, name: 'Station 4')
          create(:broadcast, id: 7, stations: stations, impressions: [])
          get url, headers: headers
        end

        let(:expected) { {"name"=>"Station 4", "broadcasts-count"=>1, "total"=>"0.0", "expected-amount"=>"0.0"} }
        it { is_expected.to eq(expected) }
      end
    end
  end

  context 'given only TV stations and only one station per broadcast plus some impressions' do
    before(:all) do
      # Medium
      medium = create(:medium, id: 0, name: :tv)
      # STATIONS
      create(:station, medium: medium, id: 1, name: 'Station 1')
      create(:station, medium: medium, id: 2, name: 'Station 2')
      create(:station, medium: medium, id: 3, name: 'Station 3')

      # BROADCASTS
      # Station 1
      create(:broadcast, id: 1, station_ids: [1])
      create(:broadcast, id: 2, station_ids: [1])
      create(:broadcast, id: 3, station_ids: [1])

      # Station 2
      create(:broadcast, id: 4, station_ids: [2])
      create(:broadcast, id: 5, station_ids: [2])

      # Station 3
      create(:broadcast, id: 6, station_ids: [3])

      # IMPRESSIONS
      # Station1
      create(:impression, broadcast_id: 1, response: :positive, amount: 1)
      create(:impression, broadcast_id: 2, response: :positive, amount: 2)
      create(:impression, broadcast_id: 2, response: :positive, amount: 3)
      create(:impression, broadcast_id: 3, response: :positive, amount: 4)
      create(:impression, broadcast_id: 3, response: :positive, amount: 5)
      create(:impression, broadcast_id: 3, response: :positive, amount: 6)

      # Station 2
      create(:impression, broadcast_id: 4, response: :positive, amount: 1)
      create(:impression, broadcast_id: 4, response: :positive, amount: 2)
      create(:impression, broadcast_id: 4, response: :positive, amount: 3)
      create(:impression, broadcast_id: 4, response: :positive, amount: 4)
      create(:impression, broadcast_id: 5, response: :positive, amount: 5)
      create(:impression, broadcast_id: 5, response: :positive, amount: 6)
      create(:impression, broadcast_id: 5, response: :positive, amount: 7)
      create(:impression, broadcast_id: 5, response: :positive, amount: 8)
      create(:impression, broadcast_id: 5, response: :positive, amount: 9)

      # Station 3
      create(:impression, broadcast_id: 6, response: :positive, amount: 1)
      create(:impression, broadcast_id: 6, response: :positive, amount: 2)
      create(:impression, broadcast_id: 6, response: :positive, amount: 3)
      create(:impression, broadcast_id: 6, response: :positive, amount: 4)
      create(:impression, broadcast_id: 6, response: :positive, amount: 5)
    end

    after(:all) do
      clean_database!
    end

    describe 'GET' do
      describe '/statistic/stations/:id' do
        let(:url) { '/statistic/stations/1' }
        before { get url, headers: headers }
        describe 'response /data' do
          describe '#type' do
            subject { parse_json(response.body, "data/type") }
            it { is_expected.to eq 'statistic/stations' }
          end

          describe 'attribute' do
            subject { parse_json(response.body, "data/attributes/#{attribute}") }
            describe '#name' do
              let(:attribute) { 'name' }
              it { is_expected.to eq 'Station 1' }
            end

            describe '#broadcasts-count' do
              let(:attribute) { 'broadcasts-count' }
              it { is_expected.to eq 3 }
            end

            describe '#total' do
              let(:attribute) { 'total' }
              it { is_expected.to eq '21.0' }
            end

            describe '#expected_amount' do
              let(:attribute) { 'expected-amount' }
              it { is_expected.to eq '24.3' }
            end
          end
        end
      end
    end

    describe 'GET' do
      describe '/statistic/stations' do
        let(:url) { '/statistic/stations' }
        before { get url, headers: headers }

        describe 'JSON-API compliance' do
          describe 'serialized JSON' do
            describe '#id' do
              subject { parse_json(response.body, 'data/0/id') }
              it { is_expected.to eq '1' }
            end

            describe '#type' do
              subject { parse_json(response.body, 'data/0/type') }
              it { is_expected.to eq 'statistic/stations' }
            end
          end
        end

        describe 'attribute' do
          let(:range) { (0...Station.count) }
          subject { range.collect {|i| parse_json(response.body, "data/#{i}/attributes/#{attribute}") } }
          describe '#name' do
            let(:attribute) { 'name' }
            describe 'order' do
              let(:headers) { super().merge('locale' => 'en') }
              before do
                create(:station, medium: Medium.first, id: 47, name: 'Station 4')
                create(:station, medium: Medium.first, id: 11, name: 'Station 5') # this will disorder the normal enumeration
                create(:broadcast, id: 7, station_ids: [47])
                create(:broadcast, id: 8, station_ids: [11])
                get url, headers: headers # one request more
              end
              it { is_expected.to eq(['Station 1', 'Station 2', 'Station 3', 'Station 4', 'Station 5']) }
            end
          end

          describe '#broadcasts_count' do
            let(:attribute) { 'broadcasts-count' }
            it { is_expected.to eq [3, 2, 1] }
          end

          describe '#total' do
            let(:attribute) { 'total' }
            it { is_expected.to eq %w[21.0 45.0 15.0] }
          end

          describe '#expected_amount' do
            let(:attribute) { 'expected-amount' }
            it { is_expected.to eq %w[24.3 36.45 20.25] }
          end
        end


        describe 'first record' do
          subject { parse_json(response.body, 'data/0/attributes/') }
          let(:expected) { {"name"=>"Station 1", "broadcasts-count"=>3, "total"=>"21.0", "expected-amount"=>"24.3"} }
          it { is_expected.to eq(expected) }
        end
      end
    end
  end
end

context 'given one TV or radio station per broadcast and some impressions' do
  before(:all) do
    # Medium
    tv    = create(:medium, id: 0, name: :tv)
    radio = create(:medium, id: 1, name: :radio)
    # STATIONS
    create(:station, medium: tv,    id: 1, name: 'TV 1')
    create(:station, medium: radio, id: 2, name: 'Radio 2')
    create(:station, medium: radio, id: 3, name: 'Radio 3')

    # BROADCASTS
    # Station 1
    create(:broadcast, id: 1, station_ids: [1])
    create(:broadcast, id: 2, station_ids: [2])
    create(:broadcast, id: 3, station_ids: [3])

    # IMPRESSIONS
    # Station1
    create_list(:impression, 1,  broadcast_id: 1, response: :positive, amount: 13)
    create_list(:impression, 5,  broadcast_id: 2, response: :positive, amount: 7)
    create_list(:impression, 10, broadcast_id: 3, response: :positive, amount: 3)
  end

  after(:all) do
    clean_database!
  end

  describe 'GET' do
    describe '/statistic/stations?filter[medium_id]= ?' do
      let(:url) { "/statistic/stations" }
      let(:params) { { filter: { medium_id: medium_id } } }
      before { get url, params: params, headers: headers }

      describe ':medium_id = 1 (radio)' do
        let(:medium_id) { 1 }
        describe 'attribute' do
          subject { [0,1].collect {|i| parse_json(response.body, "data/#{i}/attributes/#{attribute}") } }

          describe '#name' do
            let(:attribute) { 'name' }
            it { is_expected.to eq ['Radio 2', 'Radio 3'] }
          end

          describe '#broadcasts-count' do
            let(:attribute) { 'broadcasts-count' }
            it { is_expected.to eq [1, 1] }
          end

          describe '#total' do
            let(:attribute) { 'total' }
            it { is_expected.to eq %w[35.0 30.0] }
          end

          describe '#expected-amount' do
            let(:attribute) { 'expected-amount' }
            it { is_expected.to eq %w[24.375 48.75] }
          end
        end

        describe ':medium_id = 0 (TV)' do
          let(:medium_id) { 0 }

          describe 'length' do
            subject { response.body }
            it { is_expected.to have_json_size(1) }
          end

          describe '#name' do
            it 'only names of TV stations' do
              expect(parse_json(response.body, 'data/0/attributes/name')).to eq('TV 1')
            end
          end
        end
      end
    end
  end
end

context 'given multiple stations per broadcast and some impressions' do
  before(:all) do
    # Medium
    tv    = create(:medium, id: 0, name: :tv)
    radio = create(:medium, id: 1, name: :radio)
    # STATIONS
    create(:station, medium: tv,    id: 1, name: 'TV 1')
    create(:station, medium: tv,    id: 2, name: 'TV 2')
    create(:station, medium: tv,    id: 3, name: 'TV 3')
    create(:station, medium: radio, id: 4, name: 'Radio 1')
    create(:station, medium: radio, id: 5, name: 'Radio 2')

    # BROADCASTS
    # Station 1
    create(:broadcast, id: 1, station_ids: [1, 2, 3])
    create(:broadcast, id: 2, station_ids: [2, 3])
    create(:broadcast, id: 3, station_ids: [3])
    create(:broadcast, id: 4, station_ids: [4, 5])

    # IMPRESSIONS
    create_list(:impression, 9,  broadcast_id: 1, response: :positive, amount: 6)
    create_list(:impression, 5,  broadcast_id: 2, response: :positive, amount: 8)
    create_list(:impression, 1,  broadcast_id: 3, response: :positive, amount: 12)
    create_list(:impression, 8,  broadcast_id: 4, response: :positive, amount: 4)

    # Neutral
    create_list(:impression, 10, broadcast_id: 2, response: :neutral)
  end

  after(:all) do
    clean_database!
  end

  describe 'GET' do
    describe '/statistic/stations?filter[medium_id]= ?' do
      let(:url) { "/statistic/stations" }
      let(:params) { { filter: { medium_id: medium_id } } }
      before { get url, params: params, headers: headers }

      describe ':medium_id = 0 (TV)' do
        let(:medium_id) { 0 }

        describe 'length' do
          subject { response.body }
          it { is_expected.to have_json_size(3).at_path('data') }
        end

        describe 'attribute' do
          subject { [0,1,2].collect {|i| parse_json(response.body, "data/#{i}/attributes/#{attribute}") } }
          describe '#name' do
            let(:attribute) { 'name' }
            it { is_expected.to eq ['TV 1', 'TV 2', 'TV 3'] }
          end

          describe '#broadcasts-count' do
            let(:attribute) { 'broadcasts-count' }
            it { is_expected.to eq [1, 2, 3] }
          end

          describe '#total' do
            let(:attribute) { 'total' }
            it { is_expected.to eq %w[18.0 38.0 50.0] }
          end

          describe '#expected-amount' do
            let(:attribute) { 'expected-amount' }
            it { is_expected.to eq %w[12.5454545454545454 43.9090909090909089 48.0909090909090907] }
          end
        end

        describe ':medium_id = 1 (radio)' do
          let(:medium_id) { 1 }
          describe 'length' do
            subject { response.body }
            it { is_expected.to have_json_size(2).at_path('data') }
          end

          describe 'attribute' do
            subject { [0,1].collect {|i| parse_json(response.body, "data/#{i}/attributes/#{attribute}") } }
            describe '#name' do
              let(:attribute) { 'name' }
              it { is_expected.to eq ['Radio 1', 'Radio 2'] }
            end

            describe '#broadcasts-count' do
              let(:attribute) { 'broadcasts-count' }
              it { is_expected.to eq [1.0, 1.0] }
            end

            describe '#total' do
              let(:attribute) { 'total' }
              it { is_expected.to eq %w[16.0 16.0] }
            end

            describe '#expected-amount' do
              let(:attribute) { 'expected-amount' }
              it {is_expected.to eq %w[16.7272727272727272 16.7272727272727272] }
            end
          end
        end
      end
    end
  end
end
