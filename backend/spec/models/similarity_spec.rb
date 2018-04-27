require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Similarity, type: :model do
  describe 'broadcast1_id & broadcast2_id' do
    before do
      create(:broadcast, id: 47)
      create(:broadcast, id: 11)
    end

    it_behaves_like 'database unique attribute', :similarity, broadcast1_id: 47, broadcast2_id: 11
  end

  describe '::compute_all' do
    subject { setup && Similarity.compute_all(threshold: threshold, minimum_supporters: minimum_supporters) }
    let(:minimum_supporters) { 0 }

    it 'calls delete_all' do
      expect(Similarity).to receive(:delete_all)
      Similarity.compute_all
    end

    describe 'minimum supporters == 2' do
      let(:threshold) { 0 }
      let(:minimum_supporters) { 2 }
      let(:setup) { create_list(:broadcast, 2) }

      it 'surpresses cold start similarities' do
        expect { subject }.not_to(change { Similarity.count })
      end

      context '2 broadcasts with 2 supporters each' do
        let(:setup) do
          super()
          create_list(:impression, 2, broadcast: Broadcast.first, response: :positive)
          create_list(:impression, 2, broadcast: Broadcast.last, response: :positive)
        end

        it 'saves one similarity pair' do
          expect { subject }.to change { Similarity.count }.from(0).to(1)
        end
      end
    end

    describe 'threshold == 0.5' do
      let(:threshold) { 0.5 }
      let(:setup) do
        create_list(:broadcast, 3)
        create_list(:user, 2)
        create(:impression, id: 1, broadcast: Broadcast.first, user: User.first, response: :positive)
        create(:impression, id: 2, broadcast: Broadcast.last, user: User.first, response: :positive)
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
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: :positive)
            create(:impression, id: 2, broadcast: broadcast2, user: user2, response: :positive)
            create(:impression, id: 3, broadcast: broadcast2, user: user1, response: :neutral) # ignored
          end

          it '== 0' do
            is_expected.to eq(0)
          end
        end

        context 'with exactly the same supporters' do
          let(:setup) do
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: :positive)
            create(:impression, id: 2, broadcast: broadcast2, user: user1, response: :positive)
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
            create(:impression, id: 1, broadcast: broadcast1, user: user1, response: :positive)
            create(:impression, id: 2, broadcast: broadcast1, user: user2, response: :positive)
            create(:impression, id: 3, broadcast: broadcast2, user: user1, response: :positive)
            create(:impression, id: 4, broadcast: broadcast2, user: user3, response: :positive)
            create(:impression, id: 5, broadcast: broadcast2, user: user4, response: :positive)
            create(:impression, id: 6, broadcast: broadcast2, user: user5, response: :neutral) # ignored
          end

          it '== 0.5' do
            is_expected.to eq(0.25) # 1 / 4
          end
        end
      end
    end
  end

  describe '::specific_to(:user)' do
    before { setup }
    subject { Similarity.specific_to(user1) }
    let(:broadcast1) { build(:broadcast) }
    let(:broadcast2) { build(:broadcast) }
    let(:broadcast3) { build(:broadcast) }
    let(:broadcast4) { build(:broadcast) }
    let(:user1) { create(:user, id: 1) }
    let(:user2) { create(:user, id: 2) }

    let(:setup) do
      create(:similarity, id: 1, broadcast1: broadcast1, broadcast2: broadcast2)
      create(:similarity, id: 2, broadcast1: broadcast3, broadcast2: broadcast1)
      create(:similarity, id: 3, broadcast1: broadcast3, broadcast2: broadcast4)
      create(:impression, user: user1, response: :positive, broadcast: broadcast1)
      create(:impression, user: user2, response: :positive, broadcast: broadcast3)
      create(:impression, user: user1, response: :neutral, broadcast: broadcast4)
    end

    it 'returns similarities of supported broadcasts' do
      similarity_ids = subject.map(&:id)
      expect(similarity_ids).to match_array([1, 2])
    end

    context 'user is nil' do
      subject { Similarity.specific_to(nil) }
      it { is_expected.to eq([]) }
    end
  end

  describe '#to_graph_edge' do
    subject { build(:similarity, broadcast1_id: 1, broadcast2_id: 2, value: 0.5) }
    it 'returns a hash with source id, target id and value' do
      expect(subject.to_graph_edge).to eq(
        source: 1,
        target: 2,
        value: 0.5
      )
    end
  end
end
