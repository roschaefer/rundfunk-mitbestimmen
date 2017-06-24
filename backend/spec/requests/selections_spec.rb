require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Selections', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:user)    { create :user }
  let(:positive_selection) { create(:selection, user: user, response: :positive) }
  let(:negative_selection) { create(:selection, user: user, response: :negative) }
  let(:json_body) do
    subject
    JSON.parse(response.body)
  end

  describe '*' do
    let(:url) { '/selections' } # as an example
    let(:request) { get url, params: params, headers: headers }
    context 'legacy user without auth0_uid or location' do
      before { user }
      let(:user) do
        User.skip_callback(:save, :after, :geocode_last_ip)
        user = create(:user, :without_geolocation, auth0_uid: nil)
        User.set_callback(:save, :after, :geocode_last_ip)
        user
      end

      context 'logs in the first time with AUTH0' do
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

  describe 'GET /selections' do
    let(:action) { get '/selections', params: params, headers: headers }
    let(:selections) { [positive_selection, negative_selection] }
    subject do
      selections
      action
      response
    end

    it { is_expected.to have_http_status(:unauthorized) }

    context 'signed in' do
      let(:headers) { authenticated_header(user) }

      it { is_expected.to have_http_status(:ok) }

      it 'returns selections of the current user' do
        expect(json_body['data'].length).to eq 2
        selection_json = {
          data: UnorderedArray({
                                 id: positive_selection.id.to_s,
                                 attributes: { response: 'positive' }
                               }, id: negative_selection.id.to_s,
                                  attributes: { response: 'negative' })
        }
        expect(json_body).to include_json(selection_json)
      end

      describe '?response=positive' do
        let(:params) { { filter: { response: 'positive' } } }

        it 'returns only selections with a positive response' do
          selection_json = {
            data: UnorderedArray(
              id: positive_selection.id.to_s,
              attributes: { response: 'positive' }
            )
          }
          expect(json_body).to include_json(selection_json)
        end

        it 'does not return selections with a negative response' do
          selection_json = {
            data: UnorderedArray(id: negative_selection.id.to_s)
          }
          expect(json_body).not_to include_json(selection_json)
        end
      end
    end
  end

  describe 'GET /selections/:id' do
    let(:action) { get "/selections/#{selection.id}", params: params, headers: headers }
    let(:selection) { create(:selection, user: user) }

    subject do
      selection
      action
      response
    end

    it { is_expected.to have_http_status(:unauthorized) }

    context 'signed in' do
      let(:headers) { authenticated_header(user) }

      context 'access to own selection' do
        it { is_expected.to have_http_status(:ok) }

        it 'returns selection' do
          expect(json_body['data']['id']).to eq selection.id.to_s
        end
      end

      context 'access to selection of someone else' do
        let(:selection) { create(:selection) }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  describe 'POST /selections' do
    let(:action) { post '/selections', params: params, headers: headers }

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
                type: 'selections',
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

          it 'creates a selection' do
            expect { action }.to change { Selection.count }.from(0).to(1)
          end

          it 'user creates a selection, thus he wants to pay for the broadcast' do
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

            it 'cannot create a selection for another user' do
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
