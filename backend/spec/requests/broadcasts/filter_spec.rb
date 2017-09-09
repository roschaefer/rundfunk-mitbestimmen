require 'rails_helper'

RSpec.describe 'Broadcasts', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:broadcasts) {  create_list(:broadcast, 23) }
  let(:user) { create :user }

  let(:tv)    { Medium.create(id: 0, name: 'tv') }
  let(:radio) { Medium.create(id: 1, name: 'radio') }
  let(:other) { Medium.create(id: 2, name: 'other') }

  let(:tv_broadcast)    { create(:broadcast, id: 0, medium: tv) }
  let(:radio_broadcast) { create(:broadcast, id: 1, medium: radio) }
  let(:other_broadcast) { create(:broadcast, id: 2, medium: other) }

  let(:dasErste) { create(:station, id: 47, name: 'Das Erste') }

  describe 'GET /broadcasts' do
    let(:url) { '/broadcasts' }
    let(:action) { get url, params: params, headers: headers }
    let(:js) { JSON.parse(response.body) }
    before { broadcasts }

    subject do
      action
      js
    end

    describe '?filter' do
      describe '?filter[medium]=' do
        let(:broadcasts) { [radio_broadcast, tv_broadcast, other_broadcast] }

        describe '_' do
          let(:params) { { filter: { medium: '' } } }

          it 'returns all broadcasts' do
            expect(subject['data'].length).to eq 3
            expect(Broadcast.count).to eq 3
          end
        end

        describe 'radio' do
          let(:params) { { filter: { medium: radio.id } } }

          it 'returns radio broadcasts only' do
            expect(subject['data'].length).to eq 1
            expect(subject['data'][0]['relationships']['medium']['data']['id']).to eq radio.id.to_s
          end
        end

        describe 'tv+radio' do
          let(:params) { { filter: { medium: [radio.id, tv.id] } } }

          it 'returns radio and tv broadcasts' do
            expect(subject['data'].length).to eq 2
            media = [0, 1].collect { |i| subject['data'][i]['relationships']['medium']['data']['id'] }
            expect(media.sort).to eq [tv.id.to_s, radio.id.to_s]
          end
        end

        describe 'other' do
          let(:params) { { filter: { medium: other.id } } }

          it 'returns special broadcasts only' do
            expect(subject['data'].length).to eq 1
            expect(subject['data'][0]['relationships']['medium']['data']['id']).to eq other.id.to_s
          end
        end

        describe 'unknown' do
          let(:params) { { filter: { medium: 4711 } } }

          it 'will be ignored' do
            expect(subject['data'].length).to eq 0
          end
        end
      end

      describe '?filter[station]=' do
        let(:das_erste) { create(:station, name: 'Das Erste') }
        let(:wdr_fernsehen) { create(:station, name: 'WDR Fernsehen') }
        let(:wdr_broadcast) { create(:broadcast, station: wdr_fernsehen) }
        let(:ard_broadcast) { create(:broadcast, station: das_erste) }
        let(:broadcasts) { [ard_broadcast, wdr_broadcast] }
        let(:params) { { filter: { station: wdr_fernsehen.id } } }

        it 'returns broadcasts of a given station' do
          expect(subject['data'].length).to eq 1
          expect(subject['data'][0]['relationships']['station']['data']['id']).to eq wdr_fernsehen.id.to_s
        end
      end
    end

    describe 'param filter' do
      let(:unevaluated_broadcast) { create(:broadcast) }
      let(:impression) { create(:impression, user: user) }
      let(:evaluated_broadcast) { impression.broadcast }
      let(:broadcasts) { [unevaluated_broadcast, evaluated_broadcast] }

      describe 'filter: {review: "reviewed"}' do
        let(:params) { { filter: { review: 'reviewed' } } }

        context 'not logged in' do
          it 'ignores reviewed parameter' do
            expect(subject['data'].length).to eq(2)
          end
        end

        context 'logged in' do
          let(:headers) { super().merge(authenticated_header(user)) }

          it 'returns only reviewed broadcasts' do
            expect(subject['data'].length).to eq(1)
            expect(subject['data'][0]['id'].to_i).to eq(evaluated_broadcast.id)
            expect(subject['data'][0]['attributes']['title']).to eq(evaluated_broadcast.title)
          end

          describe 'relationships' do
            context 'other users viewed reviewed broadcast, too' do
              let(:other_impression) { create(:impression, broadcast: evaluated_broadcast) }
              let(:relationships) { subject['data'][0]['relationships'] }
              before { other_impression }

              it 'included impression belongs to current user' do
                first_returned_impression = relationships['impressions']['data'][0]
                expect(first_returned_impression['id'].to_i).to eq impression.id
              end

              it 'impressions of other users are not exposed' do
                expect(Impression.count).to eq 2
                number_of_related_impressions = relationships['impressions']['data'].length
                expect(number_of_related_impressions).to eq 1
              end
            end
          end
        end
      end

      describe 'filter: {review: "unreviewed"}' do
        let(:params) { { filter: { review: 'unreviewed' } } }

        context 'not logged in' do
          it 'ignores reviewed parameter' do
            expect(subject['data'].length).to eq(2)
          end
        end

        context 'logged in' do
          let(:headers) { super().merge(authenticated_header(user)) }

          it 'returns only unreviewed broadcasts' do
            expect(subject['data'].length).to eq(1)
            expect(subject['data'][0]['id'].to_i).to eq(unevaluated_broadcast.id)
            expect(subject['data'][0]['attributes']['title']).to eq(unevaluated_broadcast.title)
          end

          describe 'relationships' do
            context 'other users viewed unreviewed broadcast' do
              let(:other_impression) { create(:impression, broadcast: evaluated_broadcast) }
              let(:relationships) { subject['data'][0]['relationships'] }
              before { other_impression }

              it 'impressions are not exposed at all' do
                expect(Impression.count).to eq 2
                number_of_related_impressions = relationships['impressions']['data'].length
                expect(number_of_related_impressions).to eq 0
              end
            end
          end
        end
      end
    end
  end
end
