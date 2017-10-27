require 'rails_helper'

RSpec.describe Statistic::Broadcast, type: :model do
  describe '::view_definition' do
    subject { described_class.view_definition }
    it { is_expected.to be_a(String) }
    it { is_expected.to include('impressions') }
  end

  describe '#average' do
    subject { described_class.find_broadcast_as_of(broadcast, time).average }

    before(:all) do
      @broadcast = create(:broadcast)
      @t1 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive, amount: 2.0)
      @t2 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive)
      # ^^^ amount is nil, so this does not not descrease #average
      @t3 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive, amount: 7.0)
      @t4 = Time.now
      create(:impression, response: :positive, amount: 8.0)
      @t5 = Time.now
      create(:impression, broadcast: @broadcast, response: :neutral)
      @t6 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive, amount: 0.0)
      @t7 = Time.now
    end

    after(:all) do
      clean_database!
    end

    let(:broadcast) { @broadcast }

    describe 't1' do
      let(:time) { @t1 }
      it { is_expected.to eq(nil) }
    end

    describe 't2' do
      let(:time) { @t2 }
      it { is_expected.to eq(2.0) }
    end

    describe 't3' do
      let(:time) { @t3 }
      it { is_expected.to eq(2.0) }
    end

    describe 't4' do
      let(:time) { @t4 }
      it { is_expected.to eq(4.5) }
    end

    describe 't5' do
      let(:time) { @t5 }
      it { is_expected.to eq(4.5) }
    end

    describe 't6' do
      let(:time) { @t6 }
      it { is_expected.to eq(4.5) }
    end

    describe 't7' do
      let(:time) { @t7 }
      it { is_expected.to eq(3.0) }
    end
  end

  describe '#impressions' do
    subject { described_class.find_broadcast_as_of(broadcast, time).impressions }

    before(:all) do
      @broadcast = create(:broadcast)
      @t1 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive, amount: 3.0)
      @t2 = Time.now
      create(:impression, broadcast: @broadcast, response: :neutral)
      @t3 = Time.now
      create(:impression, response: :neutral)
      @t4 = Time.now
    end

    after(:all) do
      clean_database!
    end

    let(:broadcast) { @broadcast }

    describe 't1' do
      let(:time) { @t1 }
      it { is_expected.to eq(0) }
    end

    describe 't2' do
      let(:time) { @t2 }
      it { is_expected.to eq(1) }
    end

    describe 't3' do
      let(:time) { @t3 }
      it { is_expected.to eq(2) }
    end

    describe 't4' do
      let(:time) { @t4 }
      it { is_expected.to eq(2) }
    end
  end

  describe '#total_amount' do
    subject { described_class.find_broadcast_as_of(broadcast, time).total }

    describe 'constant increase' do
      before(:all) do
        @broadcast = create(:broadcast)
        @t1 = Time.now
        create(:impression, broadcast: @broadcast, response: :positive, amount: 3.0)
        @t2 = Time.now
        create(:impression, broadcast: @broadcast, response: :positive, amount: 5.0)
        @t3 = Time.now
        create(:impression, broadcast: @broadcast, response: :positive, amount: 7.0)
        @t4 = Time.now
      end

      after(:all) do
        clean_database!
      end

      let(:broadcast) { @broadcast }

      describe 't1' do
        let(:time) { @t1 }
        it { is_expected.to eq(0.0) }
      end

      describe 't2' do
        let(:time) { @t2 }
        it { is_expected.to eq(3.0) }
      end

      describe 't3' do
        let(:time) { @t3 }
        it { is_expected.to eq(8.0) }
      end

      describe 't4' do
        let(:time) { @t4 }
        it { is_expected.to eq(15.0) }
      end
    end

    describe 'up and down, because of deleted and changed impressions' do
      before(:all) do
        @broadcast = create(:broadcast)
        i1 = create(:impression, broadcast: @broadcast, response: :positive, amount: 7.0)
        @t1 = Time.now
        i2 = create(:impression, broadcast: @broadcast, response: :positive, amount: 3.0)
        @t2 = Time.now
        i1.destroy
        @t3 = Time.now
        i3 = create(:impression, broadcast: @broadcast, response: :positive, amount: 11.0)
        @t4 = Time.now
        i3.amount = 2.0
        i3.save
        @t5 = Time.now
        i2.amount = nil
        i2.response = :neutral
        i2.save
        @t6 = Time.now
      end

      after(:all) do
        clean_database!
      end
      let(:broadcast) { @broadcast }

      describe 't1' do
        let(:time) { @t1 }
        it { is_expected.to eq(7.0) }
      end

      describe 't2' do
        let(:time) { @t2 }
        it { is_expected.to eq(10.0) }
      end

      describe 't3' do
        let(:time) { @t3 }
        it { is_expected.to eq(3.0) }
      end

      describe 't4' do
        let(:time) { @t4 }
        it { is_expected.to eq(14.0) }
      end

      describe 't5' do
        let(:time) { @t5 }
        it { is_expected.to eq(5.0) }
      end

      describe 't6' do
        let(:time) { @t6 }
        it { is_expected.to eq(2.0) }
      end
    end
  end

  describe '#approval' do
    subject { described_class.find_broadcast_as_of(broadcast, time).approval }
    before(:all) do
      @broadcast = create(:broadcast)
      @t1 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive)
      @t2 = Time.now
      create(:impression, broadcast: @broadcast, response: :neutral)
      @t3 = Time.now
      create(:impression, response: :neutral)
      @t4 = Time.now
      create(:impression, broadcast: @broadcast, response: :neutral)
      create(:impression, broadcast: @broadcast, response: :neutral)
      @t5 = Time.now
    end

    after(:all) do
      clean_database!
    end
    let(:broadcast) { @broadcast }

    describe 't1' do
      let(:time) { @t1 }
      it { is_expected.to eq(nil) }
    end

    describe 't2' do
      let(:time) { @t2 }
      it { is_expected.to eq(1.0) }
    end

    describe 't3' do
      let(:time) { @t3 }
      it { is_expected.to eq(0.5) }
    end

    describe 't4' do
      let(:time) { @t4 }
      it { is_expected.to eq(0.5) }
    end

    describe 't5' do
      let(:time) { @t5 }
      it { is_expected.to eq(0.25) }
    end
  end

  describe '#expected_amount' do
    subject { described_class.find_broadcast_as_of(broadcast, time).expected_amount }
    before(:all) do
      @broadcast = create(:broadcast)
      @t1 = Time.now
      create(:impression, broadcast: @broadcast, response: :positive, amount: 3.0)
      @t2 = Time.now
      create(:impression, broadcast: @broadcast, response: :neutral)
      @t3 = Time.now
      create(:impression, response: :neutral)
      @t4 = Time.now
      create(:impression, response: :positive, amount: 5.0)
      @t5 = Time.now
      i = create(:impression, broadcast: @broadcast, response: :positive, amount: 2.0)
      @t6 = Time.now
      i.amount = 7.0
      i.save
      @t7 = Time.now
    end

    after(:all) do
      clean_database!
    end
    let(:broadcast) { @broadcast }

    describe 't1' do
      let(:time) { @t1 }
      it { is_expected.to eq(0.0) }
    end

    describe 't2' do
      let(:time) { @t2 }
      it { is_expected.to eq(3.0) }
    end

    describe 't3' do
      let(:time) { @t3 }
      it { is_expected.to eq(3.0) }
    end

    describe 't4' do
      let(:time) { @t4 }
      it { is_expected.to eq(2.0) }
    end

    describe 't5' do
      let(:time) { @t5 }
      it { is_expected.to eq(4.0) }
    end

    describe 't6' do
      let(:time) { @t6 }
      it { is_expected.to eq(6.0) }
    end

    describe 't7' do
      let(:time) { @t7 }
      it { is_expected.to eq(9.0) }
    end
  end
end
