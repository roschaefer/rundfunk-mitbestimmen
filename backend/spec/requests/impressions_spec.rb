require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Impressions', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:user)    { create :user }
  let(:positive_impression) { create(:impression, user: user, response: :positive) }
  let(:neutral_impression) { create(:impression, user: user, response: :neutral) }
  let(:json_body) do
    subject
    JSON.parse(response.body)
  end

  describe '*' do
    let(:url) { '/impressions' } # as an example
    let(:request) { get url, params: params, headers: headers }
    context 'legacy user without auth0_uid or location' do
      before { user }
      let(:user) do
        User.skip_callback(:save, :after, :geocode_last_ip)
        user = create(:user, :without_geolocation, auth0_uid: nil)
        User.set_callback(:save, :after, :geocode_last_ip)
        user
      end

      context 'login the first time with AUTH0' do
        let(:headers) do
          user.auth0_uid = 'email|58d072bf0bdcab0a0ecee8ad'
          super().merge(authenticated_header(user))
        end

        describe 'updates the location of the user' do
          around(:each) do |example|
            VCR.use_cassette('auth0_access_token_and_geo_ip_lookup') do
              Sidekiq::Testing.inline! do
                example.run
              end
            end
          end

          specify { expect { request }.to change { User.first.location? }.from(false).to(true) }
          specify { expect { request }.to change { User.first.latitude }.from(nil).to(52.4) }
          specify { expect { request }.to change { User.first.longitude }.from(nil).to(13.0667) }
        end
      end
    end
  end

  describe 'GET /impressions' do
    let(:action) { get '/impressions', params: params, headers: headers }
    let(:impressions) { [positive_impression, neutral_impression] }
    subject do
      impressions
      action
      response
    end

    it { is_expected.to have_http_status(:unauthorized) }

    context 'signed in' do
      let(:headers) { authenticated_header(user) }

      it { is_expected.to have_http_status(:ok) }
      it 'returns impressions of the current user' do
        expect(subject.body).to have_json_size(2).at_path('data')
        data = parse_json(subject.body, 'data').sort_by { |key| key['attributes']['response'] }
        expect(data.first['id']).to eq(neutral_impression.id.to_s)
        expect(data.first['attributes']).to include('response' => 'neutral')
        expect(data.second['id']).to eq(positive_impression.id.to_s)
        expect(data.second['attributes']).to include('response' => 'positive')
      end

      describe '?response=positive' do
        let(:params) { { filter: { response: 'positive' } } }

        it 'returns only impressions with a positive response' do
          expect(subject.body).to have_json_size(1).at_path('data')
          expect(parse_json(subject.body, 'data/0/attributes')).to include('response' => 'positive')
          expect(parse_json(subject.body, 'data/0/id')).to eq positive_impression.id.to_s
        end
      end
    end
  end

  describe 'GET /impressions/:id' do
    let(:action) { get "/impressions/#{impression.id}", params: params, headers: headers }
    let(:impression) { create(:impression, user: user) }

    subject do
      impression
      action
      response
    end

    it { is_expected.to have_http_status(:unauthorized) }

    context 'signed in' do
      let(:headers) { authenticated_header(user) }

      context 'access to own impression' do
        it { is_expected.to have_http_status(:ok) }

        it 'returns impression' do
          expect(json_body['data']['id']).to eq impression.id.to_s
        end
      end

      context 'access to impression of someone else' do
        let(:impression) { create(:impression) }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  describe 'POST /impressions' do
    let(:action) { post '/impressions', params: params, headers: headers }

    subject do
      action
      response
    end

    it { is_expected.to have_http_status(:unauthorized) }

    context 'signed in' do
      let(:headers) { authenticated_header(user) }

      context 'given a broadcast' do
        let(:broadcast) { create :broadcast }
        describe 'sending params[response,user_id,broadcast_id]' do
          let(:params) do
            {
              data: {
                type: 'impressions',
                attributes: {
                  response: :positive
                },
                relationships: {
                  broadcast: {
                    data: { id: broadcast.id, type: 'broadcasts' }
                  }
                }
              }
            }
          end

          it 'creates a impression' do
            expect { action }.to change { Impression.count }.from(0).to(1)
          end

          it 'user creates a impression, thus he wants to pay for the broadcast' do
            action
            user.reload
            expect(user.liked_broadcasts).to include(broadcast)
          end

          context 'given another user' do
            let(:other_user) { create :user }
            let(:params) do
              params = super()
              params[:data][:relationships][:user] = {
                data: {
                  id: other_user.id,
                  type: 'users'
                }
              }
              params
            end

            it 'cannot create a impression for another user' do
              action
              user.reload
              other_user.reload
              expect(other_user.liked_broadcasts).to be_empty
              expect(user.liked_broadcasts).to include(broadcast)
            end
          end
        end
      end
    end
  end
end
