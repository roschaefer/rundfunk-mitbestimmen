require 'rails_helper'
RSpec.describe 'ChartData', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }

  context 'no stations at all' do
    describe 'GET' do
      describe '/chart_data/diffs/:medium_id' do
        let(:url) { '/chart_data/diffs/0' }
        before { get url, params: params, headers: headers }
        subject { response }
        it { is_expected.to have_http_status(:ok) }
      end
    end
  end

  context 'given only TV stations, broadcasts and impressions' do
    let(:medium) { Medium.first }
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
      Impression.destroy_all
      User.destroy_all
      Schedule.destroy_all
      Broadcast.destroy_all
      Station.destroy_all
      Medium.destroy_all
    end

    describe 'GET' do
      describe '/chart_data/diffs/:medium_id' do
        let(:url) { '/chart_data/diffs/0' }
        before { get url, params: params, headers: headers }

        describe 'JSON-API compliance' do
          describe 'serialized JSON' do
            it 'id is always 0' do
              expect(parse_json(response.body, 'data/id')).to eq '0'
            end

            it 'type is "chart-data/diffs"' do
              expect(parse_json(response.body, 'data/type')).to eq 'chart-data/diffs'
            end
          end
        end

        describe 'chart data' do
          describe 'categories' do
            it 'contains station names ordered alphabetically' do
              create(:station, medium: medium, id: 47, name: 'Station 4')
              create(:station, medium: medium, id: 11, name: 'Station 5') # this will disorder the normal enumeration
              create(:broadcast, id: 7, station_ids: [47])
              create(:broadcast, id: 8, station_ids: [11]) # and add some broadcasts, to have the new stations included
              get url, params: params, headers: headers.merge('locale' => 'en')
              expect(parse_json(response.body, 'data/attributes/categories')).to eq(['Station 1', 'Station 2', 'Station 3', 'Station 4', 'Station 5'])
            end
          end

          describe 'series' do
            describe 'names' do
              context 'if request header contains locale "en"' do
                it 'get translated to english' do
                  get url, params: params, headers: headers.merge('locale' => 'en')
                  expect(parse_json(response.body, 'data/attributes/series/0/name')).to eq 'Actual amount'
                  expect(parse_json(response.body, 'data/attributes/series/1/name')).to eq 'Expected amount'
                end
              end
            end

            describe 'data' do
              it 'contains actual amounts for every station' do
                expect(parse_json(response.body, 'data/attributes/series/0/data')).to eq [21.0, 45.0, 15.0]
              end

              it 'contains expected amounts for every station' do
                expect(parse_json(response.body, 'data/attributes/series/1/data')).to eq [24.3, 36.45, 20.25]
              end

              it 'contains number of broadcasts 0' do
                expect(parse_json(response.body, 'data/attributes/series/2/data')).to eq [3, 2, 1]
              end

              it 'arrays align with categories array' do
                category             = parse_json(response.body, 'data/attributes/categories/0')
                actual_amount        = parse_json(response.body, 'data/attributes/series/0/data/0')
                expected_amount      = parse_json(response.body, 'data/attributes/series/1/data/0')
                number_of_broadcasts = parse_json(response.body, 'data/attributes/series/2/data/0')
                expect([category, actual_amount, expected_amount, number_of_broadcasts]).to eq(['Station 1', 21.0, 24.3, 3])
              end

              context 'if no broadcast of a station ever received an impression' do
                before do
                  create(:broadcast, id: 7, stations: create_list(:station, 1, medium: medium, id: 4, name: 'Station 4'), impressions: [])
                  get url, params: params, headers: headers
                end

                it 'actual amount is 0.0' do
                  expect(parse_json(response.body, 'data/attributes/series/0/data')).to eq [21.0, 45.0, 15.0, 0.0]
                end

                it 'expected amount is 0.0' do
                  expect(parse_json(response.body, 'data/attributes/series/1/data')).to eq [24.3, 36.45, 20.25, 0.0]
                end

                it 'number of broadcasts is 0' do
                  expect(parse_json(response.body, 'data/attributes/series/2/data')).to eq [3, 2, 1, 0]
                end
              end
            end
          end
        end
      end
    end
  end

  context 'given TV and radio stations' do
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
      Impression.destroy_all
      User.destroy_all
      Schedule.destroy_all
      Broadcast.destroy_all
      Station.destroy_all
      Medium.destroy_all
    end

    describe 'GET' do
      describe '/chart_data/diffs/:medium_id' do
        let(:url) { "/chart_data/diffs/#{medium_id}" }
        before { get url, params: params, headers: headers }

        describe 'chart data' do
          describe ':medium_id = 1 (radio)' do
            let(:medium_id) { 1 }

            describe 'categories' do
              it 'contains only names of radio stations' do
                expect(parse_json(response.body, 'data/attributes/categories')).to eq(['Radio 2', 'Radio 3'])
              end
            end

            describe 'series' do
              describe 'data' do
                it 'contains actual amounts for every radio station' do
                  expect(parse_json(response.body, 'data/attributes/series/0/data')).to eq [35.0, 30.0]
                end

                it 'contains expected amounts for every radio station' do
                  expect(parse_json(response.body, 'data/attributes/series/1/data')).to eq [24.375, 48.75]
                end

                it 'contains number of broadcasts 0 for every radio station' do
                  expect(parse_json(response.body, 'data/attributes/series/2/data')).to eq [1.0, 1.0]
                end
              end
            end
          end

          describe ':medium_id = 0 (TV)' do
            let(:medium_id) { 0 }
            describe 'categories' do
              it 'contains only names of TV stations' do
                expect(parse_json(response.body, 'data/attributes/categories')).to eq(['TV 1'])
              end
            end
          end
        end
      end
    end
  end
end
