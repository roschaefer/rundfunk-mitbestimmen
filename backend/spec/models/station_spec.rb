require 'rails_helper'

RSpec.describe Station, type: :model do
  let(:station) { create(:station) }

  describe '#medium' do
    context 'missing' do
      subject { build(:station, medium: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#broadcasts_count' do
    it 'updates when adding broadcasts' do
      station
      broadcast = create(:broadcast)
      expect{ broadcast.update(station: station) }.to change{station.broadcasts_count}.from(0).to(1)
    end

    it 'updates when removing broadcasts' do
      broadcast = create(:broadcast, station: station)
      expect{ broadcast.update(station: nil) }.to change{station.broadcasts_count}.from(1).to(0)
    end
  end
end
