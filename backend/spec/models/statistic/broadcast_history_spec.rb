require 'rails_helper'

RSpec.describe Statistic::BroadcastHistory, type: :model do
  describe '#initialize' do
    let(:broadcast_history) { described_class.new(timestamps: timestamps, statistics: statistics) }

    context 'given some statistics' do
      let(:timestamps) { [4.minutes.ago, 3.minutes.ago, 2.minutes.ago, 1.minute.ago] }
      let(:statistics) do
        [
          instance_double('Statistic::Broadcast', id: 1, title: 'Some Broadcast', impressions: 3, approval: 0.0,  average: nil, total: 0.0),
          instance_double('Statistic::Broadcast', id: 1, title: 'Some Broadcast', impressions: 4, approval: 0.25, average: 4.0, total: 4.0),
          instance_double('Statistic::Broadcast', id: 1, title: 'Some Broadcast', impressions: 5, approval: 0.4,  average: 2.0, total: 5.0),
          instance_double('Statistic::Broadcast', id: 1, title: 'Some Broadcast', impressions: 6, approval: 0.5,  average: 3.0, total: 9.0)
        ]
      end

      describe '#id' do
        subject { broadcast_history.id }
        it { is_expected.to eq(1) }
      end

      describe '#title' do
        subject { broadcast_history.title }
        it { is_expected.to eq('Some Broadcast') }
      end

      describe '#impressions' do
        subject { broadcast_history.impressions }
        it { is_expected.to eq([3, 4, 5, 6]) }
      end

      describe '#approval' do
        subject { broadcast_history.approval }
        it { is_expected.to eq([0.0, 0.25, 0.4, 0.5]) }
      end

      describe '#average' do
        subject { broadcast_history.average }
        it { is_expected.to eq([nil, 4.0, 2.0, 3.0]) }
      end

      describe '#total' do
        subject { broadcast_history.total }
        it { is_expected.to eq([0.0, 4.0, 5.0, 9.0]) }
      end
    end
  end
end
