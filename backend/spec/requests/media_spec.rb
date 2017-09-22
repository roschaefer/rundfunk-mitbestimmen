require 'rails_helper'

RSpec.describe 'Media', type: :request do
  let(:params) { {} }
  let(:headers) { {} }
  describe 'GET' do
    let(:request) { get url, params: params, headers: headers }
    describe '/media' do
      let(:url) { media_path }

      describe 'response' do
        before { request }
        subject { response }
        it { is_expected.to have_http_status(200) }
      end
    end

    context 'given a medium' do
      before { medium }

      describe '/media/:id' do
        let(:url) { medium_path(medium) }

        describe 'translations' do
          let(:medium) { create(:medium, name_de: 'Fernsehen', name_en: 'Television') }

          context 'when logged in' do
            # let(:user) { create(:user) }
            let(:user) { create(:user, locale: 'en') }
            let(:headers) { super().merge(authenticated_header(user)) }

            describe 'response is translated according to user setting' do
              before { request }
              subject { parse_json(response.body, 'data/attributes/name') }
              pending('issue #183, user has no locale column yet') do
                it { is_expected.to eq 'Television' }
              end
            end
          end
        end
      end
    end
  end
end
