require 'rails_helper'

RSpec.describe Selection, type: :model do
  { response: nil, user: nil, broadcast: nil }.to_a.each do |pair|
    describe "#{pair.first} nil" do
      subject { build(:selection, Hash[*pair]) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#amount' do
    describe 'must be positive' do
      subject { build(:selection, amount: -1) }
      it { is_expected.not_to be_valid }
    end

    context 'with a negative response but not-nil amount' do
      subject { build(:selection, response: :negative, amount: 1) }
      it { is_expected.not_to be_valid }
    end

    context 'given a user has spent his BUDGET already' do
      let(:user) { create :user }
      let(:existing_selection) { create(:selection, user: user, amount: Selection::BUDGET) }
      before { existing_selection }
      describe 'create a selection' do
        describe 'with amount > 0 for the same user' do
          subject { build(:selection, user: user, amount: 0.5) }
          it 'sum per user never exceeds the BUDGET' do
            is_expected.not_to be_valid
          end
        end

        describe 'create a selection with amount > 0 for another user' do
          subject { build(:selection, amount: 0.5) }
          it 'does not matter' do
            is_expected.to be_valid
          end
        end
      end
      describe 'update an existing selection' do
        subject { existing_selection }
        describe 'invalid if sum exceeds the BUDGET' do
          before { subject.amount = Selection::BUDGET + 0.5 }
          it { is_expected.not_to be_valid }
        end
        describe 'valid if sum does not exceed BUDGET' do
          before { subject.amount = Selection::BUDGET - 0.5 }
          it { is_expected.to be_valid }
        end
      end
    end
  end

  describe '#user' do
    describe '#broadcast' do
      let(:user) { create :user }
      let(:broadcast) { create :broadcast }
      describe 'user can vote only once' do
        before { create(:selection, user: user, broadcast: broadcast) }
        it 'selection is invalid' do
          second_selection = build(:selection, user: user, broadcast: broadcast)
          expect(second_selection).not_to be_valid
        end

        it 'database constraint' do
          second_selection = build(:selection, user: user, broadcast: broadcast)
          expect { second_selection.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end
end
