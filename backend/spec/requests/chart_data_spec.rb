require 'rails_helper'
RSpec.describe 'ChartData', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:action) { get url, params: params, headers: headers }
  let(:js) { JSON.parse(response.body) }

  describe 'GET' do
    context 'given some selections and some stations' do
      before { selections }
      let(:stations) { (1..3).collect { |i| create(:station, name: "Station #{i}") } }
      let(:broadcasts) do
        [
          create(:broadcast, station: stations[0]),
          create(:broadcast, station: stations[0]),
          create(:broadcast, station: stations[1]),
          create(:broadcast, station: stations[1]),
          create(:broadcast, station: stations[2])
        ]
      end

      let(:selections) do
        broadcasts.each_with_index do |b, i|
          create_list(:selection, (i + 1), broadcast: b, response: :positive, amount: (i + 3))
        end
      end

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

          describe 'stations with broadcasts but without selections' do
            it 'assigns 0 to stations without selections' do
              # let last selection point on first broadcast
              Selection.where(broadcast: broadcasts.last).find_each do |s|
                s.broadcast = broadcasts.first
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
