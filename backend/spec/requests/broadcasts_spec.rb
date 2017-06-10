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

    it 'returns a limited set of broadcast' do
      expect(subject['data'].length).to eq(10)
    end

    it 'returns the total number of broadcasts' do
      expect(subject['meta']['total-count']).to eq 23
    end

    describe 'with additional query parameter' do
      describe '?q=' do
        let(:params) { { q: 'find me' } }

        before { create(:broadcast, title: 'This is an interesting broadcast, find me') }

        it 'returns only relevant broadcasts' do
          expect(subject['data'].length).to eq(1)
          found_title = js['data'][0]['attributes']['title']
          expect(found_title).to eq 'This is an interesting broadcast, find me'
        end

        describe 'query parameter empty' do
          let(:params) { { q: '' } }
          it 'is ignored' do
            expect(subject['data'].length).to eq(10)
          end
        end
      end
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

    describe 'relationships' do
      describe '#medium' do
        let(:broadcasts) { [tv_broadcast] }
        it 'exposes the medium' do
          expect(subject['data'][0]['relationships']['medium']['data']['id']).to eq(tv.id.to_s)
        end
      end

      describe '#selections' do
        before  { create(:selection) }
        subject do
          action
          js['data'][0]['relationships']['selections']['data']
        end

        it 'does not expose foreign selections' do
          is_expected.to be_empty
        end
      end
    end

    describe 'pagination' do
      before do
        create_list(:broadcast, 10)
      end

      it 'returns a reduced set' do
        expect(subject['data'].length).to eq 10
      end

      context 'page param' do
        let(:params) { { page: 4 } }
        it 'returns the next page' do
          expect(Broadcast.count).to eq 33
          expect(subject['data'].length).to eq 3
        end
      end
    end

    describe 'param filter' do
      let(:unevaluated_broadcast) { create(:broadcast) }
      let(:selection) { create(:selection, user: user) }
      let(:evaluated_broadcast) { selection.broadcast }
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
            context 'other users voted on reviewed broadcast, too' do
              let(:other_selection) { create(:selection, broadcast: evaluated_broadcast) }
              let(:relationships) { subject['data'][0]['relationships'] }
              before { other_selection }

              it 'included selection belongs to current user' do
                first_returned_selection = relationships['selections']['data'][0]
                expect(first_returned_selection['id'].to_i).to eq selection.id
              end

              it 'selections of other users are not exposed' do
                expect(Selection.count).to eq 2
                number_of_related_selections = relationships['selections']['data'].length
                expect(number_of_related_selections).to eq 1
              end
            end
          end
        end
      end

      describe 'randomization ' do
        before do
          create_list(:broadcast, 23)
        end
        let(:params) { { sort: 'random' } }

        context 'params { random: null }' do
          before do
            get url, params: params, headers: headers
            @first_request_ids = JSON.parse(response.body)['data'].collect { |json| json['id'] }
            get url, params: params, headers: headers
            @seconds_request_ids = JSON.parse(response.body)['data'].collect { |json| json['id'] }
          end

          it 'shuffles result set' do
            expect(@first_request_ids).not_to eq(@seconds_request_ids)
            expect(@first_request_ids).not_to match_array(@seconds_request_ids)
          end
        end

        context 'given random seed' do
          before do
            @request_ids = []
            get url, params: params.merge(seed: seed[0]), headers: headers
            @request_ids << JSON.parse(response.body)['data'].collect { |json| json['id'] }
            get url, params: params.merge(seed: seed[1]), headers: headers
            @request_ids << JSON.parse(response.body)['data'].collect { |json| json['id'] }
            get url, params: params.merge(seed: seed[2]), headers: headers
            @request_ids << JSON.parse(response.body)['data'].collect { |json| json['id'] }
          end

          describe 'random seeds not in [-1, 1]' do
            let(:seed) { [10, 10, 10] }
            it 'is ignored, ie. deterministic' do
              expect(@request_ids[0]).to eq(@request_ids[1])
              expect(@request_ids[0]).to match_array(@request_ids[1])
              expect(@request_ids[0]).to eq(@request_ids[2])
              expect(@request_ids[0]).to match_array(@request_ids[2])
            end
          end

          describe 'invalid random seeds' do
            let(:seed) { %w[foo bar baz] }
            it 'is ignored, ie. deterministic' do
              expect(@request_ids[0]).to eq(@request_ids[1])
              expect(@request_ids[0]).to match_array(@request_ids[1])
              expect(@request_ids[0]).to eq(@request_ids[2])
              expect(@request_ids[0]).to match_array(@request_ids[2])
            end
          end

          describe 'same random seeds' do
            let(:seed) { [0.1, 0.1, 0.1] }
            it 'pagination is deterministic' do
              expect(@request_ids[0]).to eq(@request_ids[1])
              expect(@request_ids[0]).to match_array(@request_ids[1])
              expect(@request_ids[0]).to eq(@request_ids[2])
              expect(@request_ids[0]).to match_array(@request_ids[2])
            end
          end

          context 'different random seeds' do
            let(:seed) { [-1, 0.2, 1.0] }
            it 'pagination is non-deterministic' do
              expect(@request_ids[0]).not_to eq(@request_ids[1])
              expect(@request_ids[0]).not_to match_array(@request_ids[1])
              expect(@request_ids[0]).not_to eq(@request_ids[2])
              expect(@request_ids[0]).not_to match_array(@request_ids[2])
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
            context 'other users voted on unreviewed broadcast' do
              let(:other_selection) { create(:selection, broadcast: evaluated_broadcast) }
              let(:relationships) { subject['data'][0]['relationships'] }
              before { other_selection }

              it 'selections are not exposed at all' do
                expect(Selection.count).to eq 2
                number_of_related_selections = relationships['selections']['data'].length
                expect(number_of_related_selections).to eq 0
              end
            end
          end
        end
      end
    end
  end

  describe 'POST /broadcasts' do
    before { radio }

    let(:params) do
      {
        data: {
          type: 'broadcasts',
          attributes: {
            title: 'Nice broadcast',
            description: 'A nice broadcast, everybody will love it'
          }, relationships: {
            medium: {
              data: {
                id: '1',
                type: 'media'
              }
            }
          }
        }
      }
    end

    let(:action) { post '/broadcasts/', params: params, headers: headers }

    context 'logged in' do
      let(:headers) { super().merge(authenticated_header(user)) }
      describe 'creates a broadcast' do
        before { action }
        subject { Broadcast.first }
        specify { expect(subject.medium).to eq radio }
      end

      context 'duplicate broadcast' do
        let(:user) { create(:user, :admin) }
        it 'renders the proper error message' do
          create(:broadcast, title: 'Nice broadcast')
          action
          json = JSON.parse(response.body)
          expect(json['errors'].first['detail']).to include('ist bereits vergeben')
        end
      end

      context 'as guest' do
        let(:user) { create(:user, :guest) }
        it 'not allowed to create new broadcasts' do
          expect { action }.not_to(change { Broadcast.count })
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'as contributor' do
        let(:user) { create(:user, :contributor) }
        it 'allowed to create new broadcasts' do
          expect { action }.to(change { Broadcast.count })
          expect(response).to have_http_status(:created)
        end

        it 'stores the user who created it' do
          action
          expect(Broadcast.first.creator).to eq user
        end
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }
        it 'allowed to create new broadcasts' do
          expect { action }.to(change { Broadcast.count }.from(0).to(1))
          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe 'PATCH /broadcasts' do
    before do
      other
      dasErste
    end

    let(:broadcast) { tv_broadcast }
    let(:action) { patch "/broadcasts/#{broadcast.id}", params: params, headers: headers }
    let(:params) do
      {
        data: {
          type: 'broadcasts',
          attributes: {
          }, relationships: {
            medium: {
              data: {
                id: '2',
                type: 'media'
              }
            },
            station: {
              data: {
                id: '47',
                type: 'stations'
              }
            }
          }
        }
      }
    end

    context 'logged in' do
      let(:headers) { super().merge(authenticated_header(user)) }
      context 'as contributor' do
        let(:user) { create(:user, :contributor) }

        it 'is allowed to change medium of a broadcast' do
          expect { action }.to(change do
            broadcast.reload
            broadcast.medium
          end.from(tv).to(other))
        end

        it 'is allowed to add a new station to a broadcasts' do
          expect { action }.to(change do
            broadcast.reload
            broadcast.station
          end.from(nil).to(dasErste))
        end
      end
    end
  end

  describe 'DELETE /broadcasts/:id' do
    let(:broadcast) { create(:broadcast) }
    let(:broadcast_id) { broadcast.id }
    before { broadcast }
    let(:action) { delete "/broadcasts/#{broadcast_id}", params: params, headers: headers }

    context 'logged in' do
      let(:headers) { super().merge(authenticated_header(user)) }
      context 'as contributor' do
        let(:user) { create(:user, :contributor) }
        it 'not allowed to delete broadcasts' do
          expect { action }.not_to(change { Broadcast.count })
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }
        it 'allowed to delete broadcasts' do
          expect { action }.to(change { Broadcast.count }.from(1).to(0))
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
