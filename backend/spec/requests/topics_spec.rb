require 'rails_helper'

RSpec.describe TopicsController, type: :request do
  let(:params) { {} }
  let(:headers) { {} }

  describe 'GET' do
    let(:request) { get url, params: params, headers: headers }

    describe '/topics' do
      let(:url) { '/topics/' }

      context 'given some topics' do
        before { create_list(:topic, 3, name_en: 'Politics', name_de: 'Politik') }

        describe 'response status' do
          before { request }
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end

        describe 'response body' do
          before { request }
          subject { response.body }
          it { is_expected.to have_json_size(3).at_path('data') }

          context 'attributes/name' do
            subject { parse_json(response.body, 'data/0/attributes/name') }

            describe 'url parameter ?locale=en' do
              let(:params) { { locale: 'en' } }
              it { is_expected.to eq 'Politics' }
            end

            describe 'header locale=en' do
              let(:headers) { super().merge('locale' => 'en') }
              it { is_expected.to eq 'Politics' }
            end
          end
        end
      end
    end
  end
end
