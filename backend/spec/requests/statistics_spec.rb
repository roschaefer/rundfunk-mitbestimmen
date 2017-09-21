require 'rails_helper'

RSpec.describe 'Statistics', type: :request do
  describe 'GET' do
    let(:params) { {} }
    let(:request) { get url, params: params }

    describe '/summarized_statistics/' do
      let(:url) { '/summarized_statistics' }

      before(:all) do
        create_list(:user, 11).each do |user|
          create_list(:impression, 7, amount: 2.5, user: user)
        end
      end

      after(:all) do
        clean_database!
      end

      before { request }

      let(:data) { JSON.parse(response.body)['data'] }

      it "returns 'summarized-statistics' as type" do
        expect(data['type']).to eq 'summarized-statistics'
      end

      it 'returns the given id' do
        expect(data['id']).to eq(1)
      end

      it 'returns the number of registered users' do
        expect(data['attributes']['registered-users']).to eq 11
      end

      it 'returns the total number of impressions' do
        expect(data['attributes']['impressions']).to eq 11 * 7
      end

      it 'returns the total amount of assigned money' do
        expect(data['attributes']['assigned-money'].to_f).to eq 11 * 7 * 2.5
      end
    end
  end
end
