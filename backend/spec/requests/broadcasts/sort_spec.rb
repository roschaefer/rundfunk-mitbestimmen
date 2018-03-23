require 'rails_helper'
RSpec.describe 'Broadcasts', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }

  before { broadcasts }

  describe 'GET /broadcasts' do
    let(:url) { '/broadcasts' }
    let(:action) { get url, params: params, headers: headers }
    let(:js) { JSON.parse(response.body) }

    subject do
      action
      js
    end

    describe 'sort' do
      let(:broadcasts) do
        create(:broadcast, title: '1234')
        create(:broadcast, title: 'aaa')
        create(:broadcast, title: 'BBB')
        create(:broadcast, title: 'cCc')
        create(:broadcast, title: 'XXY')
      end

      describe 'no sort param' do
        let(:params) { { sort: nil } }
        it 'default order is ascending by title' do
          titles = subject['data'].map { |item| item['attributes']['title'] }
          expect(titles).to eq %w[1234 aaa BBB cCc XXY]
        end
      end

      describe '=desc' do
        let(:params) { { sort: 'desc' } }
        it 'sorts broadcasts by title in descending order' do
          titles = subject['data'].map { |item| item['attributes']['title'] }
          expect(titles).to eq %w[XXY cCc BBB aaa 1234]
        end
      end

      describe '=random' do
        let(:broadcasts) do
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
    end
  end
end
