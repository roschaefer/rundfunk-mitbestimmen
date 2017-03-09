require 'rails_helper'

RSpec.describe TopicsController, :type => :request do

  describe "GET index" do
    let(:topics) { 3.times.to_a.collect { create :topic } }
    let(:params) { {} }
    let(:headers) { authenticated_header(user) }
    let(:user) { create(:user) }
    before do
      topics
      get '/topics/', params: params, headers: headers
    end

    describe 'response status' do
      subject { response }
      it { is_expected.to have_http_status(:ok) }
    end

    describe 'response body' do
      subject { JSON.parse(response.body)['data'] }
      it 'contains 3 topis' do
        expect(subject.size).to eq 3
      end

      context 'english locale' do
        let(:topics) { [create(:topic, name_en: 'Politics', name_de: "Politik")] }
        describe 'url parameter ?locale=en' do
          let(:params) { {locale: 'en'} }
          it 'translates to english' do
            expect(subject.first["attributes"]['name']).to eq 'Politics'
          end
        end

        describe 'header locale=en' do
          let(:headers) { super().merge( 'locale' => 'en' ) }
          it 'translates to english' do
            expect(subject.first["attributes"]['name']).to eq 'Politics'
          end
        end
      end
    end

  end
end
