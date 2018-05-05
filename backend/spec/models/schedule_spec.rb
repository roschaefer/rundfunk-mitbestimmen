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
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'paper_trail' do
    let(:broadcast) { create(:broadcast, stations: [station]) }
    describe 'add another station to broadcast' do
      it 'creates another version' do
        broadcast
        new_station = create(:station)
        expect { broadcast.stations << new_station }.to(change { PaperTrail::Version.where(item_type: 'Schedule').count }.by(1))
      end
    end

    describe 'remove a station from a broadcast' do
      before do
        broadcast
        station
      end
      it 'creates another version' do
        expect { broadcast.update(stations: []) }.to(change { PaperTrail::Version.where(item_type: 'Schedule').count }.by(1))
      end

      it 'does not remove the station, only the join model' do
        broadcast.update(stations: [])
        expect(Broadcast.count).to eq 1
        expect(Station.count).to eq 1
      end
    end
  end
end
