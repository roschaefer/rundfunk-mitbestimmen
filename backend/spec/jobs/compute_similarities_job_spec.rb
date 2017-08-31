require 'rails_helper'

RSpec.describe ComputeSimilaritiesJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    subject { job.perform }
    it 'result in empty similarities' do
      expect{ subject }.not_to(change{ Similarity.count })
    end 

    context 'given two broadcasts' do
      before { create_list(:broadcast, 2) }
      context 'given a user supporting both' do
        let(:user) { create(:user) }
        before do
          create(:selection, user: user, broadcast: Broadcast.first, response: :positive)
          create(:selection, user: user, broadcast: Broadcast.last, response: :positive)
        end
        it 'results in a similarity between the two broadcast' do
          expect{ subject }.to(change{ Similarity.count }.from(0).to(1))
        end

        describe 'score of similarity' do
          before { job.perform }
          let(:similarity) { Similariy.first }
          subject { similarity.score }
          it { is_expected.to eq 1.0 }
        end
      end
    end
  end
end
