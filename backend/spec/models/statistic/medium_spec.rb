require 'rails_helper'

RSpec.describe Statistic::Medium, type: :model do
  let(:medium) { create(:medium) }
  subject { described_class.find(medium.id) }
  context 'medium without broadcasts' do
    it { is_expected.to be_present }
  end

  context 'medium with a broadcast' do
    context 'broadcast without impressions' do
      let(:medium) { create(:medium, broadcasts: create_list(:broadcast, 1)) }
      it { is_expected.to be_present }
    end
  end
end
