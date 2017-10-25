require 'rails_helper'

RSpec.describe Statistic::HistoricalKpi, type: :model do
  before(:all) do
    clean_database!
  end

  # HISTORICAL KPIS TO TEST:
  # => impressions
  # => approval
  # => average
  # => total
  # => expected_amount

  let(:broadcast) { create(:broadcast) }

  subject { described_class.find(broadcast.id) }

  # WITHOUT IMPRESSIONS
  describe 'without any impressions' do
    # EXPECTED KPI VALUES:
    # => impressions = 0
    # => approval = nil
    # => average = nil
    # => total = 0
    # => expected_amount = 0
    it 'there is a record for every broadcast' do
      is_expected.to be_present
    end

    it 'has 0 impressions' do
      expect(subject.impressions).to eq 0
    end

    it 'has no approval' do
      expect(subject.approval).to be_nil
    end

    it 'has no average' do
      expect(subject.average).to be_nil
    end

    it 'has 0 total' do
      expect(subject.total).to eq 0
    end

    it 'has no expected amount' do
      expect(subject.expected_amount).to be_nil
    end
  end

  # WITH IMPRESSIONS
  describe 'with impressions' do
    without_transactional_fixtures do
      context 'only neutral impressions' do
        # EXPECTED KPI VALUES:
        # => average = 0
        before do
          create(:impression, broadcast: broadcast, response: :neutral)
        end

        describe '#average' do
          it 'returns 0' do
            expect(subject.average).to eq 0
          end
        end
      end

      context 'before first impression' do
        # EXPECTED KPI VALUES:
        # => impressions = 0
        # => approval = 0
        # => average = 0
        # => total = 0
        # => expected_amount = 0
        before(:all) do
          Timecop.freeze(1.day.ago)
          broadcast = create(:broadcast)
          Timecop.return
          @before_impression_timestamp = Time.now.utc
          create(:impression, broadcast: broadcast, response: :positive, amount: 5)
          @historical_kpis = described_class.as_of(@before_impression_timestamp).find(broadcast.id)
        end

        it 'has 0 impressions' do
          expect(@historical_kpis.impressions).to eq 0
        end

        it 'has no approval' do
          expect(@historical_kpis.approval).to be_nil
        end

        it 'has no average' do
          expect(@historical_kpis.average).to be_nil
        end

        it 'has 0 total' do
          expect(@historical_kpis.total).to eq 0
        end

        it 'has no expected amount' do
          expect(@historical_kpis.expected_amount(date: @before_impression_timestamp)).to be_nil
        end
      end

      context 'after first impression' do
        # EXPECTED KPI VALUES:
        # at given time in history
        # => impressions = impressions count
        # => approval = positive impressions / total impressions
        # => average = total assigned / positive impressions
        # => total = sum amount on impressions
        # => expected_amount = impressions count / average amount per selection
        # => average amount per selection = total / impression (for all broadcasts)
        before(:all) do
          Timecop.freeze(1.day.ago)
          broadcast = create(:broadcast)
          Timecop.return
          create(:impression, broadcast: broadcast, response: :positive, amount: 5)
          sleep 1
          @after_impression_timestamp = Time.now.utc
          @historical_kpis = described_class.as_of(@after_impression_timestamp).find(broadcast.id)
        end

        it 'has 1 impression' do
          expect(@historical_kpis.impressions).to eq 1
        end

        it 'has approval 1' do
          expect(@historical_kpis.approval).to eq 1
        end

        it 'has average 5' do
          expect(@historical_kpis.average).to eq 5
        end

        it 'has total 5' do
          expect(@historical_kpis.total).to eq 5
        end

        it 'has expected amount 5' do
          allow(Impression).to receive(:average_amount_per_selection).with(@after_impression_timestamp).and_return(5)
          expect(@historical_kpis.expected_amount(date: @after_impression_timestamp)).to eq 5 # impression * average_amount_per_selection
        end
      end
    end
  end
end
