require 'rails_helper'

RSpec.describe Statistic, type: :model do
  let(:broadcast) { create(:broadcast) }

  subject { Statistic.find(broadcast.id) }

  context 'given only neutral selections' do
    before { create(:selection, broadcast: broadcast, response: :neutral) }

    describe '#average' do
      it 'returns zero' do
        expect(subject.average).to eq 0.0
      end
    end
  end

  context 'given some selections' do
    before do
      create(:selection, broadcast: broadcast, response: :positive, amount: 2.3)
      create(:selection, broadcast: broadcast, response: :positive, amount: 1.5)
      create(:selection, broadcast: broadcast, response: :positive, amount: 7.1)
      create(:selection, broadcast: broadcast, response: :positive, amount: 4.8)
      3.times { create(:selection, broadcast: broadcast, response: :neutral) }
      2.times { create(:selection, broadcast: broadcast, response: :negative) }
      create(:user) # one for a missing user
    end

    describe '#votes' do
      it 'number of selections per broadcast' do
        expect(subject.votes).to eq 9
      end
    end

    describe '#approval' do
      it 'yields positive/total' do
        expect(subject.approval).to eq 0.444444444444444
      end
    end

    describe '#average' do
      it 'how much money per broadcast per capita' do
        expect(subject.average).to eq (15.7/4.0)
      end
    end

    describe '#total' do
      it 'how much money per broadcast in total' do
        expect(subject.total).to eq 15.7
      end
    end
  end
end
