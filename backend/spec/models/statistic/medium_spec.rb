require 'rails_helper'

RSpec.describe Statistic::Medium, type: :model do
  let(:medium) { create(:medium) }
  subject { described_class.find(medium.id) }

  describe 'translations' do
    let(:medium) { create(:medium, name_en: 'Television', name_de: 'Fernsehen') }
    let(:statistic) { described_class.find(medium.id) }
    describe '#name' do
      subject { statistic.name }
      it { is_expected.to eq 'Fernsehen' }
    end
  end

  context 'medium without broadcasts' do
    it { is_expected.to be_present }
  end

  context 'medium with a broadcast' do
    context 'broadcast without impressions' do
      let(:medium) { create(:medium, broadcasts: create_list(:broadcast, 1)) }
      it { is_expected.to be_present }
    end
  end

  context 'broadcasts with impressions' do
    before do
      create_list(:impression, 3, broadcast: broadcasts[0], response: :positive, amount: 3.0)
      create_list(:impression, 4, broadcast: broadcasts[0], response: :neutral)
      create_list(:impression, 5, broadcast: broadcasts[1], response: :positive, amount: 2.0)
      create_list(:impression, 6, broadcast: broadcasts[2], response: :positive, amount: 1.0)
      create_list(:impression, 7, response: :positive, amount: 1.0)
    end
    let(:broadcasts) { create_list(:broadcast, 3, medium: medium) }
    let(:medium) { create(:medium) }
    let(:statistic) { Statistic::Medium.first }

    describe '#broadcasts_count' do
      subject { statistic.broadcasts_count }
      it { is_expected.to eq 3 }
    end

    describe '#total' do
      subject { statistic.total }
      it { is_expected.to eq (3*3 + 5*2 + 6*1) }
    end

    describe '#expected_amount' do
      subject { statistic.expected_amount }
      let(:average) { (32.0/25.0) }
      it { is_expected.to eq(average*18.0) }
    end
  end
end
