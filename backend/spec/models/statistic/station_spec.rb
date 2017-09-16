require 'rails_helper'

RSpec.describe Statistic::Station, type: :model do
  let(:station) { create(:station) }
  subject { described_class.find(station.id) }
  context 'station without broadcasts' do
    it { is_expected.to be_present }
  end

  context 'station with a broadcast' do
    context 'broadcast without impressions' do
      let(:station) { create(:station, broadcasts: create_list(:broadcast, 1)) }
      it { is_expected.to be_present }
    end
  end
end
