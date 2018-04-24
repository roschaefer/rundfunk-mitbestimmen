require 'rails_helper'

RSpec.describe Statistic::Broadcast, type: :model do
  let(:broadcast) { create(:broadcast) }

  subject { described_class.find(broadcast.id) }

  context 'without any impressions' do
    it 'there is a record for every broadcast' do
      is_expected.to be_present
    end
  end

  context 'given only neutral impressions' do
    before { create(:impression, broadcast: broadcast, response: :neutral) }

    describe '#average' do
      it 'is nil' do
        expect(subject.average).to eq nil
      end
    end
  end

  context 'given some impressions' do
    before do
      create(:impression, broadcast: broadcast, response: :positive, amount: 2.3)
      create(:impression, broadcast: broadcast, response: :positive, amount: 1.5)
      create(:impression, broadcast: broadcast, response: :positive, amount: 7.1)
      create(:impression, broadcast: broadcast, response: :positive, amount: 4.8)
      6.times { create(:impression, broadcast: broadcast, response: :neutral) }
      create(:user) # one for a missing user
    end

    describe '#impressions' do
      it 'number of impressions per broadcast' do
        expect(subject.impressions).to eq 10
      end
    end

    describe '#approval' do
      it 'yields positive/(positive + neutral)' do
        expect(subject.approval).to eq(0.4)
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
    describe 'given broadcasts with varying number of impressions', issue: 221 do
      before(:all) do
        # create the records in the database
        create_list(:impression, 2,  response: :positive, amount: 15.0, broadcast: create(:broadcast, id: 4711)) # <= that's our broadcast for now
        create_list(:impression, 3,  response: :positive, amount: 10.0, broadcast: create(:broadcast))
        create_list(:impression, 5, response: :positive, amount: 5.0, broadcast: create(:broadcast))
      end

      after(:all) do
        clean_database!
      end

      let(:broadcast) { Broadcast.find(4711) }

      let(:sum_of_all_amounts) { 2 * 15.0 + 3 * 10.0 + 5 * 5.0 }
      let(:number_of_impressions) { 2 + 3 + 5 }
      let(:average_amount_per_impression) { (sum_of_all_amounts / number_of_impressions) }

      def expected_amount_of_broadcast
        described_class.find(broadcast.id).expected_amount
      end

      it '= number_of_impressions(broadcast) * ( sum_of_all_amounts / number_of_impressions)' do
        expect(expected_amount_of_broadcast).to eq(2 * (sum_of_all_amounts / number_of_impressions)) # 17
      end

      it 'is based on the number of impressions of the broadcast' do
        expect { create(:impression, broadcast: broadcast, response: :positive, amount: 3.0) }.to(change { expected_amount_of_broadcast })
      end

      it 'is based on the number of impressions in total' do
        expect { Impression.first.destroy }.to(change { expected_amount_of_broadcast })
      end

      it 'is based on the sum of all amounts' do
        expect { Impression.last.update_attributes(amount: 15.0) }.to(change { expected_amount_of_broadcast })
      end

      it 'will decrease for every neutral impression (amount = 0)' do
        expect { create_list(:impression, 6, response: :neutral) }.to(change { expected_amount_of_broadcast }.from(17).to(10.625))
      end

      it 'will increase for every positive impression with amount > average_of_all_amounts' do
        # old: 2 * 7.5
        # new: 2 * 9
        expect { create(:impression, response: :positive, amount: 14.0) }.to(change { expected_amount_of_broadcast }.from(17).to(18))
      end

      it 'will increase for every impression of the specific broadcast' do
        # old: 2 * 7.5
        # new: 4 * 85.0/16.0
        expect { create_list(:impression, 6, response: :neutral, broadcast: broadcast) }.to(change { expected_amount_of_broadcast }.from(17).to(8 * (85.0 / 16.0)))
      end

      it 'will increase even more for every positive impression of the specific broadcast' do
        # old: 2 * 7.5
        # new: 3 * 9
        expect { create(:impression, response: :positive, amount: 14.0, broadcast: broadcast) }.to(change { expected_amount_of_broadcast }.from(17).to(27))
      end
    end
  end

  describe "#approval_by(:state_code)" do
    subject { Statistic::Broadcast.find(broadcast.id) }

    before do
      create(:user, state_code: "1")
      create(:user, state_code: "2")
      create(:user, state_code: "2")
    end

    it "returns one entry for each user state_code" do
      expect(subject.approval_by(:state_code).keys.sort).to eq(["1", "2"])
    end

    it "assigns to each entry the state_code specific approval value" do
      allow(subject).to receive(:approval_by_state).with("1").and_return(0.5)
      allow(subject).to receive(:approval_by_state).with("2").and_return(0.3)
      expect(subject.approval_by(:state_code)["1"]).to eq(0.5)
      expect(subject.approval_by(:state_code)["2"]).to eq(0.3)
    end
  end

  describe "#approval_by_state(state)" do
    subject { Statistic::Broadcast.find(broadcast.id) }

    context "the broadcast has impressions for a state_code" do
      before do
        user1 = create(:user, state_code: "1")
        user2 = create(:user, state_code: "1")
        user3 = create(:user, state_code: "1")
        user4 = create(:user, state_code: "1")
        user5 = create(:user, state_code: "2")
        user6 = create(:user, state_code: "2")
        create(:impression, broadcast: broadcast, response: :positive, user: user1)
        create(:impression, broadcast: broadcast, response: :positive, user: user2)
        create(:impression, broadcast: broadcast, response: :positive, user: user3)
        create(:impression, broadcast: broadcast, response: :neutral, user: user4)
        create(:impression, broadcast: broadcast, response: :neutral, user: user5)
        create(:impression, broadcast: broadcast, response: :positive, user: user6)
      end

      # approval is the positive impression rate
      it "returns approval based on users of a given state" do
        expect(subject.approval_by_state("1")).to eq (3.0/4.0)
        expect(subject.approval_by_state("2")).to eq (1.0/2.0)
      end
    end

    context "the broadcast has no impressions for the state_code" do
      it "returns 0" do
        expect(subject.approval_by_state("NON-EXISTING")).to eq(0)
      end
    end

  end
end
