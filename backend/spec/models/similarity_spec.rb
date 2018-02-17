require 'rails_helper'

RSpec.describe Similarity, type: :model do
  describe '::compute_all' do
    describe 'threshold == 0.5' do
      subject { setup && Similarity.compute_all(0.5) }
      let(:setup) do
        create_list(:broadcast, 3)
        create_list(:user, 2)
        create(:impression, id: 1, broadcast: Broadcast.first, user: User.first, response: :positive)
        create(:impression, id: 2, broadcast: Broadcast.last, user: User.first, response: :positive)
      end

      it 'calls delete_all' do
        expect(Similarity).to receive(:delete_all)
        Similarity.compute_all
      end

      it 'saves one similarity pair' do
        expect { subject }.to change { Similarity.count }.from(0).to(1)
      end
    end

    describe 'default threshold' do
      before { setup && Similarity.compute_all }
      subject { Similarity.first.value }
      let(:broadcast1) { build(:broadcast) }
      let(:broadcast2) { build(:broadcast) }
      let(:user1) { build(:user) }
      let(:user2) { build(:user) }

      describe 'the value of the first created similarity' do
        context 'no common users with positive impressions (supporters)' do
          let(:setup) do
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
            create(:impression, id: 2, broadcast: broadcast2, user: user2, response: 1)
            create(:impression, id: 3, broadcast: broadcast2, user: user1, response: :neutral) # ignored
          end

          it '== 0' do
            is_expected.to eq(0)
          end
        end

        context 'with exactly the same supporters' do
          let(:setup) do
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
            create(:impression, id: 2, broadcast: broadcast2, user: user1, response: 1)
          end

          it '== 1' do
            is_expected.to eq(1)
          end
        end

        context 'with half supporters in common' do
          let(:user3) { build(:user) }
          let(:user4) { build(:user) }
          let(:user5) { build(:user) }

          let(:setup) do
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
            create(:impression, id: 2, broadcast: broadcast1, user: user2, response: 1)
            create(:impression, id: 3, broadcast: broadcast2, user: user1, response: 1)
            create(:impression, id: 4, broadcast: broadcast2, user: user3, response: 1)
            create(:impression, id: 5, broadcast: broadcast2, user: user4, response: 1) # ignored
            create(:impression, id: 6, broadcast: broadcast2, user: user5, response: :neutral) # ignored
          end

          it '== 0.5' do
            is_expected.to eq(0.25) # 1 / 4
          end
        end
      end
    end
  end
end
