require 'rails_helper'

RSpec.describe Similarity, type: :model do
  describe 'compute_all' do
    subject { Similarity.compute_all }

    before do
      create_list(:broadcast, 3)
      create_list(:user, 2)
      create(:impression, id: 1, broadcast: Broadcast.first, user: User.first, response: 1)
      create(:impression, id: 2, broadcast: Broadcast.last, user: User.first, response: 1)
    end

    it "calls delete_all" do
      expect(Similarity).to receive(:destroy_all)
      Similarity.compute_all
    end

    it "saves one similarity pair" do
      expect{subject}.to change{Similarity.count}.from(0).to(1)
    end
  end

  describe 'compute' do
    subject { Similarity.compute(broadcast1, broadcast2) }
    let(:broadcast1) {build(:broadcast)}
    let(:broadcast2) {build(:broadcast)}
    let(:user1) {build(:user)}
    let(:user2) {build(:user)}

    describe 'no common users with positive impressions (supporters)' do
      before do
        create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
        create(:impression, id: 2, broadcast: broadcast2, user: user2, response: 1)
        create(:impression, id: 3, broadcast: broadcast2, user: user1, response: :neutral) #ignored
      end

      it "has value 0" do
          expect(subject.value).to eq(0)
      end
    end

    describe 'with exactly the same supporters' do
      before do
        create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
        create(:impression, id: 2, broadcast: broadcast2, user: user1, response: 1)
      end

      it "has value 1" do
        expect(subject.value).to eq(1)
      end
    end

    describe 'with half supporters in common' do
      let(:user3) {build(:user)}
      let(:user4) {build(:user)}
      let(:user5) {build(:user)}

      before do
        create(:impression, id: 1, broadcast: broadcast1, user: user1, response: 1)
        create(:impression, id: 2, broadcast: broadcast1, user: user2, response: 1)
        create(:impression, id: 3, broadcast: broadcast2, user: user1, response: 1)
        create(:impression, id: 4, broadcast: broadcast2, user: user3, response: 1)
        create(:impression, id: 5, broadcast: broadcast2, user: user4, response: 1) # ignored
        create(:impression, id: 6, broadcast: broadcast2, user: user5, response: :neutral) # ignored
      end

      it "has value 0.5" do
        expect(subject.value).to eq(0.25) # 1 / 4
      end
    end
  end
end
