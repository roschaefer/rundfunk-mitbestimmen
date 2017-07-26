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
        expect(subject.average).to eq(15.7 / 4.0)
      end
    end

    describe '#total' do
      it 'how much money per broadcast in total' do
        expect(subject.total).to eq 15.7
      end
    end
  end

  describe '#expected_amount', issue: 221 do
    describe 'given broadcasts with varying number of votes', issue: 221 do

      before(:all) do
        # create the records in the database
        create_list(:selection, 2,  response: :positive, amount: 15.0, broadcast: create(:broadcast, id: 4711)) # <= that's our broadcast for now
        create_list(:selection, 3,  response: :positive, amount: 10.0, broadcast: create(:broadcast))
        create_list(:selection, 5, response: :positive, amount: 5.0, broadcast: create(:broadcast))
      end

      after(:all) do
        Selection.destroy_all
        User.destroy_all
        Broadcast.destroy_all
      end

      let(:broadcast) { Broadcast.find(4711) }

      let(:sum_of_all_amounts) { 2*15.0 + 3*10.0 + 5*5.0 }
      let(:number_of_votes) { 2 + 3 + 5 }
      let(:average_amount_per_selection) { (sum_of_all_amounts / number_of_votes) }

      def expected_amount_of_broadcast
        Statistic.find(broadcast.id).expected_amount
      end

      it '= number_of_votes(broadcast) * ( sum_of_all_amounts / number_of_votes)' do
        expect(expected_amount_of_broadcast).to eq( 2 * (sum_of_all_amounts / number_of_votes) ) # 17
      end

      it 'is based on the number of votes of the broadcast' do
        expect{ create(:selection, broadcast: broadcast, response: :positive, amount: 3.0) }.to(change{ expected_amount_of_broadcast })
      end

      it 'is based on the number of votes in total' do
        expect{ Selection.first.destroy }.to(change{ expected_amount_of_broadcast })
      end

      it 'is based on the sum of all amounts' do
        expect{ Selection.last.update_attributes(amount: 15.0) }.to(change{ expected_amount_of_broadcast })
      end

      it 'will decrease for every neutral vote (amount = 0)' do
        expect { create_list(:selection, 6, response: :neutral) }.to(change{ expected_amount_of_broadcast }.from(17).to(10.625))
      end

      it 'will increase for every positive vote with amount > average_of_all_amounts' do
        # old: 2 * 7.5
        # new: 2 * 9
        expect { create(:selection, response: :positive, amount: 14.0) }.to(change{ expected_amount_of_broadcast }.from(17).to(18))
      end

      it 'will increase for every vote of the specific broadcast' do
        # old: 2 * 7.5
        # new: 4 * 85.0/16.0
        expect { create_list(:selection, 6, response: :neutral, broadcast: broadcast) }.to(change{ expected_amount_of_broadcast }.from(17).to( 8 * (85.0/16.0) ))
      end

      it 'will increase even more for every positive vote of the specific broadcast' do
        # old: 2 * 7.5
        # new: 3 * 9
        expect { create(:selection, response: :positive, amount: 14.0, broadcast: broadcast) }.to(change{ expected_amount_of_broadcast }.from(17).to(27))
      end
    end
  end
end
