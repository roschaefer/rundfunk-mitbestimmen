require 'rails_helper'

RSpec.describe 'Statistic::Broadcast', type: :request do
  describe 'GET' do
    let(:params) { {} }
    let(:request) { get url, params: params }

    describe '/broadcasts' do
      let(:impressions) do
        amount = 3
        create_list(:broadcast, 3).each do |broadcast|
          amount += 1
          create(:impression, broadcast: broadcast, amount: amount)
          create(:impression, broadcast: broadcast, amount: amount)
          create(:impression, broadcast: broadcast, amount: amount)
        end
      end
      let(:url) { '/statistic/broadcasts' }
      let(:data) do
        impressions
        request
        JSON.parse(response.body)['data']
      end

      it 'orders by total amount descending by default' do
        sorted = data.sort { |b1, b2| b1['attributes']['total'] <=> b2['attributes']['total'] }
        expect(data).to eq sorted.reverse
      end

      context 'given :order params' do
        let(:params) {  { column: 'average', direction: 'asc' } }

        it 'orders by average and ascending' do
          sorted = data.sort { |b1, b2| b1['attributes']['average'] <=> b2['attributes']['average'] }
          expect(data).to eq sorted
        end
      end

      context 'given :order params average and ascending' do
        let(:params) { { column: 'impressions', direction: 'asc' } }
        let(:impressions) do
          impressions = [3, 2, 4]
          impressions.each do |impression|
            broadcast = create(:broadcast)
            create_list(:impression, impression, broadcast: broadcast)
          end
        end

        it 'orders by number of impressions and ascending' do
          impressions
          request
          data = JSON.parse(response.body)['data']
          sorted = data.sort { |b1, b2| b1['attributes']['impressions'] <=> b2['attributes']['impressions'] }
          expect(data).to eq sorted
        end
      end

      describe 'per_page' do
        let(:params) { { per_page: 1 } }

        it 'reduces list of items' do
          expect(data.length).to eq 1
        end

        it 'pages will never overlap' do
          broadcasts = create_list(:broadcast, 10)
          broadcasts.shuffle.each do |broadcast|
            # create a nice random list of impressions with same amount
            create(:impression, response: :neutral, broadcast: broadcast)
            create(:impression, response: :neutral, broadcast: broadcast)
            create(:impression, response: :neutral, broadcast: broadcast)
          end
          # Statistics have same total

          ids_per_request = Array.new(10) do |i|
            get url, params: { per_page: 1, page: (i + 1) }
            json = JSON.parse(response.body)
            json['data'].collect { |entry| entry['id'] }
          end
          expect(ids_per_request.length).to eq 10
          expect(ids_per_request.flatten).to eq ids_per_request.flatten.uniq
        end
      end

      context 'given invalid :order params' do
        let(:params) { { column: 'foo', direction: 'bar' } }

        it 'will be ignored' do
          sorted = data.sort { |b1, b2| b1['attributes']['total'] <=> b2['attributes']['total'] }
          expect(data).to eq sorted.reverse
        end
      end
    end
  end
end
