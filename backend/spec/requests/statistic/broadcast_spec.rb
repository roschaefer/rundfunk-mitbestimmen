require 'rails_helper'

RSpec.describe 'Statistic::Broadcast', type: :request do
  describe 'GET' do
    let(:headers) { {} }
    let(:params) { {} }
    let(:request) { get url, params: params, headers: headers }

    context 'historical data', helpers: :time do
      before(:all) do
        @t0 = 8.days.ago
        @t1 = 7.days.ago
        @t2 = 6.days.ago
        @t3 = 5.days.ago
        @t4 = 4.days.ago
        @t5 = 3.days.ago
        @t6 = 2.days.ago
        @t7 = 1.days.ago
        @t8 = 0.days.ago
        data = [
          { response: :positive, amount: 2.0, from: (@t2 - 1.second), to: nil },
          { response: :positive, amount: nil, from: (@t3 - 1.second), to: nil },
          { response: :positive, amount: 7.0, from: (@t4 - 1.second), to: nil },
          { response: :neutral,  amount: nil, from: (@t5 - 1.second), to: nil },
          { response: :positive, amount: 6.0, from: (@t6 - 1.second), to: nil },
          { response: :positive, amount: 0.0, from: (@t7 - 1.second), to: (@t8 - 1.second) }
        ]
        travel_to(@t1) { @broadcast = create(:broadcast, title: 'b', id: 4711) }
        data.each do |d|
          impression = create(:impression, broadcast: @broadcast, response: d[:response], amount: d[:amount])
          h = impression.history.first
          h.class.amend_period!(h.hid, d[:from], d[:to])
        end
        last_impression = Impression.last
        last_impression.amount = 10.0
        last_impression.save!
        h = last_impression.history.last
        h.class.amend_period!(h.hid, @t8 - 1.second, nil)
      end

      after(:all) do
        clean_database!
      end

      describe '/broadcasts/:id' do
        let(:url) { '/statistic/broadcasts/4711' }

        describe '?as_of' do
          let(:params) { { as_of: time } }

          describe 'response' do
            before { request }
            subject { parse_json(response.body, 'data/attributes') }

            describe 't1' do
              let(:time) { @t1 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 0, 'approval' => nil, 'average' => nil, 'total' => '0.0') }
            end

            describe 't2' do
              let(:time) { @t2 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 1, 'approval' => '1.0', 'average' => '2.0', 'total' => '2.0') }
            end

            describe 't3' do
              let(:time) { @t3 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 2, 'approval' => '1.0', 'average' => '2.0', 'total' => '2.0') }
            end

            describe 't4' do
              let(:time) { @t4 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 3, 'approval' => '1.0', 'average' => '4.5', 'total' => '9.0') }
            end

            describe 't5' do
              let(:time) { @t5 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 4, 'approval' => '0.75', 'average' => '4.5', 'total' => '9.0') }
            end

            describe 't6' do
              let(:time) { @t6 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 5, 'approval' => '0.8', 'average' => '5.0', 'total' => '15.0') }
            end

            describe 't7' do
              let(:time) { @t7 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 6, 'approval' => '0.83333333333333333333', 'average' => '3.75', 'total' => '15.0') }
            end

            describe 'now' do
              let(:time) { @t8 }
              it { is_expected.to eq('title' => 'b', 'impressions' => 6, 'approval' => '0.83333333333333333333', 'average' => '6.25', 'total' => '25.0') }
            end
          end
        end
      end

      describe '/broadcasts/:id/temporal' do
        let(:url) { '/statistic/broadcasts/4711/temporal' }

        describe 'response' do
          before { request }

          describe '?from=&to=&chunks=' do
            let(:params) { { from: @t0.to_json, to: @t8.to_json, day: 1 } }
            subject { JSON.parse(response.body) }

            it 'returns history of #total_amount by default' do
              is_expected.to match_array [
                [@t0.as_json,  '0.0'],
                [@t1.as_json,  '0.0'],
                [@t2.as_json,  '2.0'],
                [@t3.as_json,  '2.0'],
                [@t4.as_json,  '9.0'],
                [@t5.as_json,  '9.0'],
                [@t6.as_json, '15.0'],
                [@t7.as_json, '15.0'],
                [@t8.as_json, '25.0']
              ]
            end
          end
        end
      end
    end

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
        describe 'average ascending' do
          let(:params) {  { column: 'average', direction: 'asc' } }
          it 'orders by average and ascending' do
            sorted = data.sort { |b1, b2| b1['attributes']['average'] <=> b2['attributes']['average'] }
            expect(data).to eq sorted
          end
        end

        describe 'average descending' do
          let(:params) {  { column: 'average', direction: 'desc' } }
          describe '#average == nil' do
            before do
              impressions
              null_broadcast = create(:broadcast, id: 12_345)
              create(:impression, broadcast: null_broadcast, amount: nil)
              request
            end

            it 'sorted at the end' do
              expect(response.body).to have_json_size(4).at_path('data')
              # broadcst with #average is sorted at the end of the table
              expect(parse_json(response.body, 'data/3/id')).to eq '12345'
            end
          end
        end
      end

      context 'given :order params impressions and ascending' do
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
