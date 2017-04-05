require 'rails_helper'

RSpec.describe "Statistics", type: :request do
  let(:url) { '/statistics' }
  describe 'GET' do
    let(:params) { { } }
    let(:request) { get url, params: params }

    describe '/broadcasts' do
      let(:selections) do
        amount = 3
        create_list(:broadcast, 3).each do |broadcast|
          amount += 1
          create(:selection, broadcast: broadcast, amount: amount)
          create(:selection, broadcast: broadcast, amount: amount)
          create(:selection, broadcast: broadcast, amount: amount)
        end
      end
      let(:url) { "/statistics" }
      let(:data) { selections; request; JSON.parse(response.body)['data'] }

      it 'orders by total amount descending by default' do
        sorted = data.sort {|b1,b2| b1["attributes"]["total"] <=> b2["attributes"]["total"] }
        expect(data).to eq sorted.reverse
      end

      context 'given :order params average and ascending' do
        let(:params) {  {column: 'average', direction: 'asc'} }

        it 'orders by average and ascending' do
          sorted = data.sort {|b1,b2| b1["attributes"]["average"] <=> b2["attributes"]["average"] }
          expect(data).to eq sorted
        end
      end

      context 'given :order params average and ascending' do
        let(:params) {  {column: 'votes', direction: 'asc'} }
        let(:selections) do
          votes = [3,2,4]
          votes.each do |vote|
            broadcast = create(:broadcast)
            create_list(:selection, vote, broadcast: broadcast)
          end
        end

      it 'orders by number of votes and ascending' do
        selections
        request
        data = JSON.parse(response.body)['data']
        sorted = data.sort {|b1,b2| b1["attributes"]["votes"] <=> b2["attributes"]["votes"] }
        expect(data).to eq sorted
      end
    end

      describe 'per_page' do
        let(:params) {  {per_page: 1} }

        it 'reduces list of items' do
          expect(data.length).to eq 1
        end

        it 'pages will never overlap' do
          broadcasts = create_list(:broadcast, 10)
          broadcasts.shuffle.each do |broadcast|
            # create a nice random list of selections with same amount
            create(:selection, response: :neutral, broadcast: broadcast)
            create(:selection, response: :neutral, broadcast: broadcast)
            create(:selection, response: :neutral, broadcast: broadcast)
          end
          # Statistics have same total

          ids_per_request = []
          ids_per_request = 10.times.collect do |i|
            get url, params: { per_page: 1, page: (i+1)}
            json = JSON.parse(response.body)
            json['data'].collect {|entry| entry['id']}
          end
          expect(ids_per_request.length).to eq 10
          expect(ids_per_request.flatten).to eq ids_per_request.flatten.uniq
        end
      end

      context 'given invalid :order params' do
        let(:params) { {column: 'foo', direction: 'bar'} }

        it 'will be ingored' do
        sorted = data.sort {|b1,b2| b1["attributes"]["total"] <=> b2["attributes"]["total"] }
        expect(data).to eq sorted.reverse
        end
      end
    end

    describe "/summarized_statistics/:id" do
      let(:url) { "/summarized_statistics/1" }

      before(:all) do
        create_list(:user, 42).each do |user|
          create_list(:selection, 7, amount: 2.5, user: user)
        end
      end

      after(:all) do
        Selection.destroy_all
        User.destroy_all
        Broadcast.destroy_all
        Medium.destroy_all
        Station.destroy_all
      end

      before { request }

      let(:data) { JSON.parse(response.body)['data'] }

      it "returns 'summarized-statistics' as type" do
        expect(data['type']).to eq 'summarized-statistics'
      end

      it "returns the given id" do
        expect(data['id']).to eq '1'
      end

      it 'returns the number of registered users' do
        expect(data['attributes']['registered-users']).to eq 42
      end

      it 'returns the total number of selections' do
        expect(data['attributes']['votes']).to eq 42*7
      end

      it 'returns the total amount of assigned money' do
        expect(data['attributes']['assigned-money'].to_f).to eq 42*7*2.5
      end
    end
  end
end
