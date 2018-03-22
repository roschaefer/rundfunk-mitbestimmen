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
        subject { JSON.parse(response.body) }

        describe 'response' do
          before { request }

          describe '?from=@t0&to=@t8&day=1' do
            let(:params) { { from: @t0.change(usec: 0), to: @t8.change(usec: 0), day: 1 } }

            it 'returns history of #total_amount by default' do
              is_expected.to match_array [
                [@t0.change(usec: 0),  '0.0'],
                [@t1.change(usec: 0),  '0.0'],
                [@t2.change(usec: 0),  '2.0'],
                [@t3.change(usec: 0),  '2.0'],
                [@t4.change(usec: 0),  '9.0'],
                [@t5.change(usec: 0),  '9.0'],
                [@t6.change(usec: 0), '15.0'],
                [@t7.change(usec: 0), '15.0'],
                [@t8.change(usec: 0), '25.0']
              ]
            end
          end

          describe '?from=@t0&to=@t8' do
            let(:params) { { from: @t0.change(usec: 0), to: @t8.change(usec: 0) } }
            it 'every 7th day by default' do
              is_expected.to match_array [
                [@t0.change(usec: 0), '0.0'],
                [@t7.change(usec: 0), '15.0'],
                [@t8.change(usec: 0), '25.0']
              ]
            end
          end

          describe '?to=(2 months ago)' do
            let(:two_months_ago) { 2.months.ago.change(usec: 0) }
            let(:three_months_ago) { 3.months.ago.change(usec: 0) }
            let(:params) { { to: two_months_ago } }
            describe 'from 3 months ago with every 7th day by default' do
              before { two_months_ago && three_months_ago } # to precalculate dates
              it { expect(subject.size).to eq(6) }

              {
                0 => 0.days,
                1 => 7.days,
                2 => 14.days,
                3 => 21.days,
                4 => 28.days,
                5 => 1.month
              }.each do |i, duration|
                # a request may take some time, so let's take 3 seconds
                # as permissible deviation
                it { expect(Time.zone.parse(subject[i][0]).change(usec: 0)).to eq(three_months_ago + duration) }
              end
            end
          end
        end
      end
    end

    describe '/statistic/broadcasts/history/', helpers: :time do
      before(:all) do
        @t0 = ActiveSupport::TimeZone.new('UTC').parse('2017-12-01 UTC').getutc
        @t1 = ActiveSupport::TimeZone.new('UTC').parse('2018-02-01 UTC').getutc
        @t2 = ActiveSupport::TimeZone.new('UTC').parse('2018-03-01 UTC').getutc
        travel_to(@t0) do
          @b1 = create(:broadcast, title: 'b1', id: 1)
          @b2 = create(:broadcast, title: 'b2', id: 2)
          @b3 = create(:broadcast, title: 'b3', id: 3)
        end
        data = [
          # highest increase #approval
          { broadcast: @b1, at: @t0, response: :neutral,  amount: nil },
          { broadcast: @b1, at: @t1, response: :positive, amount: 2.0 },
          { broadcast: @b1, at: @t1, response: :positive, amount: 2.0 },
          { broadcast: @b1, at: @t1, response: :positive, amount: 2.0 },

          # highest increase #average
          { broadcast: @b2, at: @t0, response: :positive, amount: 0.0 },
          { broadcast: @b2, at: @t1, response: :positive, amount: 17.0 },

          # highest increase #impressions, #total
          { broadcast: @b3, at: @t1, response: :positive, amount: 3.0 },
          { broadcast: @b3, at: @t1, response: :positive, amount: 4.0 },
          { broadcast: @b3, at: @t1, response: :positive, amount: 5.0 },
          { broadcast: @b3, at: @t1, response: :positive, amount: 6.0 }
        ]
        data.each do |d|
          impression = create(:impression, broadcast: d[:broadcast], response: d[:response], amount: d[:amount])
          h = impression.history.first
          h.class.amend_period!(h.hid, d[:at], nil)
        end
      end

      after(:all) do
        clean_database!
      end

      let(:url) { '/statistic/broadcast_histories' }
      subject { JSON.parse(response.body) }

      describe 'response' do
        before { request }

        describe '?from=@t0&to=@t2' do
          let(:params) { { from: @t0, to: @t2 } }

          describe 'returns deltas of KPIs' do
            describe 'for broadcast #1' do
              subject { parse_json(response.body, 'data/0/attributes') }
              specify do
                is_expected.to eq(
                  'title' => 'b1',
                  'timestamps' => ['2017-12-01T00:00:00.000Z', '2018-03-01T00:00:00.000Z'],
                  'impressions' => [1, 4],
                  'approval' => ['0.0', '0.75'],
                  'average' => [nil, '2.0'],
                  'total' => ['0.0', '6.0']
                )
              end
            end

            describe 'for broadcast #2' do
              subject { parse_json(response.body, 'data/1/attributes') }
              specify do
                is_expected.to eq(
                  'title' => 'b2',
                  'timestamps' => ['2017-12-01T00:00:00.000Z', '2018-03-01T00:00:00.000Z'],
                  'impressions' => [1, 2],
                  'approval' => ['1.0', '1.0'],
                  'average' => ['0.0', '8.5'],
                  'total' => ['0.0', '17.0']
                )
              end
            end

            describe 'for broadcast #3' do
              subject { parse_json(response.body, 'data/2/attributes') }
              specify do
                is_expected.to eq(
                  'title' => 'b3',
                  'timestamps' => ['2017-12-01T00:00:00.000Z', '2018-03-01T00:00:00.000Z'],
                  'impressions' => [0, 4],
                  'approval' => [nil, '1.0'],
                  'average' => [nil, '4.5'],
                  'total' => ['0.0', '18.0']
                )
              end
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
