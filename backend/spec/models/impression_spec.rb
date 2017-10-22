require 'rails_helper'

RSpec.describe Impression, type: :model do
  before(:all) do
    clean_database!
  end

  { response: nil, user: nil, broadcast: nil }.to_a.each do |pair|
    describe "#{pair.first} nil" do
      subject { build(:impression, Hash[*pair]) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#amount' do
    describe 'must be positive' do
      subject { build(:impression, amount: -1) }
      it { is_expected.not_to be_valid }
    end

    context 'with a negative response but not-nil amount' do
      subject { build(:impression, response: :negative, amount: 1) }
      it { is_expected.not_to be_valid }
    end

    context 'given a user has spent his BUDGET already' do
      let(:user) { create :user }
      let(:existing_impression) { create(:impression, user: user, amount: Impression::BUDGET) }
      before { existing_impression }
      describe 'create a impression' do
        describe 'with amount > 0 for the same user' do
          subject { build(:impression, user: user, amount: 0.5) }
          it 'sum per user never exceeds the BUDGET' do
            is_expected.not_to be_valid
          end
        end

        describe 'create a impression with amount > 0 for another user' do
          subject { build(:impression, amount: 0.5) }
          it 'does not matter' do
            is_expected.to be_valid
          end
        end
      end
      describe 'update an existing impression' do
        subject { existing_impression }
        describe 'invalid if sum exceeds the BUDGET' do
          before { subject.amount = Impression::BUDGET + 0.5 }
          it { is_expected.not_to be_valid }
        end
        describe 'valid if sum does not exceed BUDGET' do
          before { subject.amount = Impression::BUDGET - 0.5 }
          it { is_expected.to be_valid }
        end
      end
    end
  end

  describe '#user' do
    describe '#broadcast' do
      let(:user) { create :user }
      let(:broadcast) { create :broadcast }
      describe 'user can view only once' do
        before { create(:impression, user: user, broadcast: broadcast) }
        it 'impression is invalid' do
          second_impression = build(:impression, user: user, broadcast: broadcast)
          expect(second_impression).not_to be_valid
        end

        it 'database constraint' do
          second_impression = build(:impression, user: user, broadcast: broadcast)
          expect { second_impression.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end

  describe 'historical data' do
    describe '#as_of' do
      without_transactional_fixtures do
     
        subject(:impression) { create(:impression) }

        it 'returns the amount assigned at a given point in time' do
          impression.update(response: :positive, amount: 5)
          t0 = Time.now.utc
          sleep 1
            
          impression.update(amount: 10)
          t1 = Time.now.utc

          expect(impression.as_of(t0).amount).to eq(5)
          expect(impression.as_of(t1).amount).to eq(10)
        end
      end
    end
  end
end
