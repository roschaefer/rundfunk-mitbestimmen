require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }

  describe 'PATCH' do
    let(:action) { patch url, params: params, headers: headers }
    describe 'locale' do
      let(:url) { '/users/whatever' }
      let(:params) do
        {
          data: {
            id: user.id,
            type: 'users',
            attributes: {
              locale: 'en'
            }
          }
        }
      end

      context 'given a user' do
        let(:user) { create(:user, locale: 'de') }
        context 'if not logged' do
          describe 'request' do
            it('does not change the current user locale') do
              expect { action }.not_to(change { user.reload.locale })
            end
          end

          describe 'response' do
            before { action }
            subject { response }
            describe('respond with status unauthorized') do
              it { is_expected.to have_http_status(:unauthorized) }
            end
          end
        end

        context 'when logged in' do
          let(:headers) { super().merge(authenticated_header(user)) }

          it('changes the value of locale') do
            expect { action }.to(change { user.reload.locale }).from('de').to('en')
          end
        end
      end
    end

    describe 'location', vcr: { cassette_name: 'reverse_geo_location' } do
      describe '/users/:id' do
        let(:url) { '/users/we_trust_our_authentication_not_your_supplied_id' }
        let(:params) do
          {
            data: {
              id: user.id,
              type: 'users',
              attributes: {
                latitude: 36.7201516,
                longitude: -4.419282
              }
            }
          }
        end
        let(:user) { create(:user, :without_geolocation) }
        before { user }

        context 'not logged in' do
          describe 'does not accept changes' do
            specify { expect { action }.not_to(change { user.reload.longitude }) }
            specify { expect { action }.not_to(change { user.reload.latitude }) }
            specify { expect { action }.not_to(change { user.reload.city }) }
            specify { expect { action }.not_to(change { user.reload.postal_code }) }
            specify { expect { action }.not_to(change { user.reload.state_code }) }
            specify { expect { action }.not_to(change { user.reload.country_code }) }

            describe 'http status' do
              before { action }
              subject { response }
              it { is_expected.to have_http_status(:unauthorized) }
            end
          end
        end

        context 'logged in' do
          let(:headers) { super().merge(authenticated_header(user)) }

          specify { expect { action }.to(change { user.reload.latitude }.to(36.7201516)) }
          specify { expect { action }.to(change { user.reload.longitude }.to(-4.419282)) }
          specify { expect { action }.to(change { user.reload.city }.to('Málaga')) }
          specify { expect { action }.to(change { user.reload.postal_code }.to('29015')) }
          specify { expect { action }.to(change { user.reload.state_code }.to('AL')) }
          specify { expect { action }.to(change { user.reload.country_code }.to('ES')) }

          context 'already geocoded user' do
            let(:user) { create(:user, latitude: 54.4, longitude: 13.0, country_code: 'DE', state_code: 'BB', city: 'Potsdam', postal_code: '14482') }
            describe 'overwrites geo location' do
              specify { expect { action }.to(change { user.reload.latitude }.to(36.7201516)) }
              specify { expect { action }.to(change { user.reload.longitude }.to(-4.419282)) }
              specify { expect { action }.to(change { user.reload.city }.to('Málaga')) }
              specify { expect { action }.to(change { user.reload.postal_code }.to('29015')) }
              specify { expect { action }.to(change { user.reload.state_code }.to('AL')) }
              specify { expect { action }.to(change { user.reload.country_code }.to('ES')) }
            end
          end
        end
      end
    end
  end

  describe 'GET' do
    let(:action) { get url, params: params, headers: headers }
    let(:user) { create(:user, latitude: 54.4, longitude: 13.0, country_code: 'DE', state_code: 'BB', city: 'Potsdam', postal_code: '14482') }
    before { user }
    describe '/users/' do
      let(:url) { '/users/' }
      let(:js) { JSON.parse(response.body) }
      subject do
        action
        response
      end

      context 'not logged in' do
        it 'does not return any location' do
          expect(subject.body).to eq('')
        end

        it { is_expected.to have_http_status(:unauthorized) }
      end

      context 'logged in' do
        let(:headers) { super().merge(authenticated_header(user)) }
        it 'returns the own location' do
          expected = {
            'latitude' => 54.4,
            'longitude' => 13.0,
            'country-code' => 'DE',
            'state-code' => 'BB',
            'city' => 'Potsdam',
            'postal-code' => '14482'
          }
          expect(parse_json(subject.body, 'data/attributes')).to include(expected)
        end
      end
    end
  end
end
