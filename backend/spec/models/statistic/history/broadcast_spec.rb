require 'rails_helper'

RSpec.describe Statistic::History::Broadcast, type: :model do
  let(:broadcast) { create(:broadcast) }

  describe 'history of a broadcast' do
    before do
      broadcast
      @t1 = Time.now
      create(:impression, broadcast: broadcast, response: :positive, amount: 3.0)
      @t2 = Time.now
      create(:impression, broadcast: broadcast, response: :positive, amount: 5.0)
      @t3 = Time.now
      create(:impression, broadcast: broadcast, response: :positive, amount: 7.0)
      @t4 = Time.now
    end

    let(:historical_statistic_broadcast) { described_class.find(broadcast.id).as_of(time) }

    describe '#total' do
      subject { historical_statistic_broadcast.total }

      describe 't1' do
        let(:time) { @t1 }
        it { is_expected.to eq(0.0) }
      end

      describe 't2' do
        let(:time) { @t1 }
        it { is_expected.to eq(3.0) }
      end

      describe 't3' do
        let(:time) { @t1 }
        it { is_expected.to eq(8.0) }
      end

      describe 't4' do
        let(:time) { @t1 }
        it { is_expected.to eq(15.0) }
      end
    end
  end
end
