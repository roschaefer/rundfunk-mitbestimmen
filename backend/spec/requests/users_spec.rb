require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }

  describe 'PATCH' do
    let(:action) { patch url, params: params, headers: headers }
  end

  describe 'GET' do
    let(:action) { get url, params: params, headers: headers }
    describe '/users/:id' do
      let(:url) { '/users/idDoesNotMatter' }
      let(:js) { JSON.parse(response.body) }
      subject do
        action
        response.body
      end

      context 'given three users' do
        let(:users) { [user] + other_users }
        let(:other_users) { create_list(:user, 3) }
        let(:user) { create(:user, latitude: 54.4, longitude: 13.0, country_code: 'DE', state_code: 'BB', city: 'Potsdam', postal_code: '14482') }
        before { users }

        context 'not logged in' do
          it 'does not return any location' do
            is_expected.to eq('null')
          end
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
            expect(parse_json(subject, 'data/attributes')).to include(expected)
          end
        end
      end
    end
  end
end
