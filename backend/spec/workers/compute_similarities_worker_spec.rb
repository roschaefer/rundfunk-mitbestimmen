require 'rails_helper'

RSpec.describe ComputeSimilaritiesWorker, type: :worker do
  describe '::minimum_supporters' do
    subject { described_class.minimum_supporters }
    context 'given 3 impressions for same broadcast' do
      before { create_list(:impression, 100, broadcast: create(:broadcast)) }
      it { is_expected.to eq 5 }
    end

    context 'given 3 impressions for different broadcast' do
      before { create_list(:impression, 3) }
      it { is_expected.to eq 0 }
    end

    context 'given no impressions' do
      it { is_expected.to eq 0 }
    end
  end
end
