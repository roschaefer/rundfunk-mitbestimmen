require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Station, type: :model do
  let(:station) { create(:station) }

  it_behaves_like 'database unique attribute', :station, name: 'JustAnotherStation'

  describe '#medium' do
    context 'missing' do
      subject { build(:station, medium: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe '#broadcasts_count' do
    before do
      station
    end

    describe 'on the station side' do
      it 'updates when adding broadcasts' do
        broadcast = create(:broadcast)
        expect { station.update(broadcasts: [broadcast]) }.to change { station.broadcasts_count }.from(0).to(1)
      end

      it 'updates when removing broadcasts' do
        create(:broadcast, stations: [station])
        expect do
          station.update(broadcasts: [])
          station.reload
        end.to change { station.broadcasts_count }.from(1).to(0)
      end
    end

    describe 'on the broadcast side' do
      it 'updates when adding the station' do
        broadcast = create(:broadcast)
        expect { broadcast.update(stations: [station]) }.to change { station.broadcasts_count }.from(0).to(1)
      end

      it 'updates when removing the station' do
        broadcast = create(:broadcast, stations: [station])
        expect do
          broadcast.update(stations: [])
          station.reload
        end.to change { station.broadcasts_count }.from(1).to(0)
      end
    end
  end
end
