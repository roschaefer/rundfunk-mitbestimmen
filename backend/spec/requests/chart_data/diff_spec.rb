require 'rails_helper'
RSpec.describe 'ChartData', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:action) { get url, params: params, headers: headers }
  let(:js) { JSON.parse(response.body) }

  context 'given selections and stations' do
    before(:all) do
      stations =  [
        create(:station, id: 1, name: 'Station 1'),
        create(:station, id: 2, name: 'Station 2'),
        create(:station, id: 3, name: 'Station 3')
      ]
      broadcasts = [
        create(:broadcast, id: 1, station_id: 1),
        create(:broadcast, id: 2, station_id: 1),

        create(:broadcast, id: 3, station_id: 2),
        create(:broadcast, id: 4, station_id: 2),

        create(:broadcast, id: 5, station_id: 3)
      ]
      selections = [
        create(:selection, broadcast_id: 1, response: :positive, amount: 3),

        create(:selection, broadcast_id: 2, response: :positive, amount: 4),
        create(:selection, broadcast_id: 2, response: :positive, amount: 4),

        create(:selection, broadcast_id: 3, response: :positive, amount: 5),
        create(:selection, broadcast_id: 3, response: :positive, amount: 5),
        create(:selection, broadcast_id: 3, response: :positive, amount: 5),

        create(:selection, broadcast_id: 4, response: :positive, amount: 6),
        create(:selection, broadcast_id: 4, response: :positive, amount: 6),
        create(:selection, broadcast_id: 4, response: :positive, amount: 6),
        create(:selection, broadcast_id: 4, response: :positive, amount: 6),

        create(:selection, broadcast_id: 5, response: :positive, amount: 7),
        create(:selection, broadcast_id: 5, response: :positive, amount: 7),
        create(:selection, broadcast_id: 5, response: :positive, amount: 7),
        create(:selection, broadcast_id: 5, response: :positive, amount: 7),
        create(:selection, broadcast_id: 5, response: :positive, amount: 7)
      ]
    end

    after(:all) do
      Selection.destroy_all
      User.destroy_all
      Broadcast.destroy_all
      Station.destroy_all
      Medium.destroy_all
    end


    describe 'GET' do
      describe '/chart_data/diffs/:id' do
        let(:url) { '/chart_data/diffs/0' }
        subject do
          action
          js
        end

        it 'assigns the id to 0' do
          expect(subject['data']['id']).to eq '0'
        end

        describe 'json' do
          it 'compares distributions between expected random and actual distribution' do
            expect(subject['data']['attributes']['series']).to eq(
              [
                { 'name' => 'Auf Abstimmungen der Nutzer basierender Betrag', 'data' => ['11.0', '39.0', '35.0'] },
                { 'name' => 'Jede Sendung erhält den gleichen Betrag', 'data' => ['34.0', '34.0', '17.0'] }
              ]
            )
          end

          it 'orders categories by name' do
            expect(subject['data']['attributes']['categories']).to eq(['Station 1', 'Station 2', 'Station 3'])
          end

          describe 'broadcasts without stations' do
            it 'do not count' do
              action
              online_broadcast = create(:broadcast, station: nil)
              create_list(:selection, 5, broadcast: online_broadcast, response: :positive, amount: 10.0)
              expect { get url, params: params, headers: headers }.not_to(change { JSON.parse(response.body) })
            end
          end

          describe 'stations with broadcasts but without selections' do
            it 'assigns 0 to stations without selections' do
              # let last selection point on first broadcast
              Selection.where(broadcast_id: 5).find_each do |s|
                s.broadcast_id = 1 # assign them to another broadcast
                s.save!
              end
              expect(subject['data']['attributes']['series']).to eq(
                [
                  { 'name' => 'Auf Abstimmungen der Nutzer basierender Betrag', 'data' => ['46.0', '39.0', '0.0'] },
                  { 'name' => 'Jede Sendung erhält den gleichen Betrag', 'data' => ['34.0', '34.0', '17.0'] }
                ]
              )
            end
          end
        end
      end
    end
  end
end
