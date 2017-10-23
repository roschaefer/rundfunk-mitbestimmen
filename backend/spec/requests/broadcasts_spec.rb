# frozen_string_literal: true

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
  let(:radio_broadcast) do
    create(:broadcast,
           id: 1,
           medium: radio,
           broadcast_url: 'https://www.zdf.de/assets/teamfoto-102~768x43')
  end
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

    describe 'relationships' do
      describe '#medium' do
        let(:broadcasts) { [tv_broadcast] }
        it 'exposes the medium' do
          expect(subject['data'][0]['relationships']['medium']['data']['id'])
            .to eq(tv.id.to_s)
        end
      end

      describe '#impressions' do
        before  { create(:impression) }
        subject do
          action
          js['data'][0]['relationships']['impressions']['data']
        end

        it 'does not expose foreign impressions' do
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
  end

  describe 'GET /broadcast/:id' do
    let(:action) { get "/broadcasts/#{radio_broadcast.id}", headers: headers }

    context 'logged in' do
      let(:headers) { super().merge(authenticated_header(user)) }
      before do
        action
      end

      describe 'http status' do
        subject { response }
        it { is_expected.to have_http_status(:ok) }
      end

      describe 'response schema' do
        subject { response }
        it { is_expected.to match_response_schema('broadcast') }
      end

      describe '#broadcast_url' do
        subject { parse_json(response.body, 'data/attributes/broadcast-url') }
        it { is_expected.to eq 'https://www.zdf.de/assets/teamfoto-102~768x43' }
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
            description: 'A nice broadcast, everybody will love it',
            image_url: 'https://www.zdf.de/assets/teamfoto-102~768x432'
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
            stations: {
              data: [{
                id: '47',
                type: 'stations'
              }]
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
            broadcast.stations.to_a
          end.from([]).to([dasErste]))
        end
      end

      describe 'remove stations' do
        let(:broadcast) { create(:broadcast, stations: [dasErste]) }
        let(:params) do
          {
            data: {
              type: 'broadcasts',
              attributes: {
              }, relationships: {
                stations: {
                  data: []
                }
              }
            }
          }
        end

        it 'is allowed to remove stations' do
          expect { action }.to(change do
            broadcast.reload
            broadcast.stations.to_a
          end.from([dasErste]).to([]))
        end

        it 'removed stations will be tracked' do
          broadcast # create broadcast and station
          expect { action }.to(change { PaperTrail::Version.count }.by(1))
        end

        it 'whodunnit is set' do
          action
          PaperTrail::Version.last.whodunnit = user.id
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
