require 'rails_helper'

RSpec.describe Impression, type: :model do
  let(:user) { create :user }
  let(:broadcast) { create :broadcast }

  { user: nil, broadcast: nil }.to_a.each do |pair|
    describe "##{pair.first}" do
      describe "is nil" do
        subject { build(:impression, Hash[*pair]) }
        it { is_expected.not_to be_valid }
        specify { expect { subject.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation) }
      end
    end
  end

  describe 'one impression per broadcast per user' do
    before { create(:impression, user: user, broadcast: broadcast) }

    specify { expect(user.broadcasts).to include(broadcast) }

    describe 'duplicate impression' do
      subject { build(:impression, user: user, broadcast: broadcast) }

      it { is_expected.not_to be_valid }
      specify { expect { subject.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique) }
    end
  end

  describe '#response' do
    describe 'is nil' do
      subject{ build(:impression, response: nil) }
      it { is_expected.to be_valid }

      context 'without factory bot' do
        subject { Impression.new(user: user, broadcast: broadcast) }
        specify { expect(subject.response).to eq('neutral') }

        context 'saved' do
          before { subject.save }
          specify { expect(subject.response).to eq('neutral') }
        end
      end
    end

    describe '== foobar' do
      specify { expect{ build(:impression, response: :foobar) }.to raise_error(ArgumentError) }
    end
  end

  describe '#amount' do
    describe 'must be positive' do
      subject { build(:impression, amount: -1) }
      it { is_expected.not_to be_valid }
    end

    context 'given a user has spent his BUDGET already' do
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
end
