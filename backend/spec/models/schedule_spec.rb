require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:station) { create(:station) }
  let(:broadcast) { create(:broadcast) }

  context 'without station' do
    subject { build(:schedule, station: nil) } 
    it { is_expected.not_to be_valid }
  end

  context 'without broadcast' do
    subject { build(:schedule, broadcast: nil) } 
    it { is_expected.not_to be_valid }
  end

  context 'two schedules for same broadcast and station' do
    before { create(:schedule, broadcast: broadcast, station: station) }
    subject  { build(:schedule, broadcast: broadcast, station: station) }
    it { is_expected.not_to be_valid }
    describe 'database' do
      subject { build(:schedule, broadcast: broadcast, station: station).save(validate: false) }
      it 'raises unique constraint error' do
        expect{ subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
