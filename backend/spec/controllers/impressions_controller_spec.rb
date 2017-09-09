require 'rails_helper'

RSpec.describe ImpressionsController, type: :controller do
  describe 'POST index' do
    let(:broadcast) { create :broadcast }
    let(:user) { create :user }
    let(:params) do
      {
        impression: {
          user: user,
          broadcast: broadcast,
          response: :positive
        }
      }
    end

    let(:request) { post :create, params: params }

    it 'requires authentication' do
      request
      expect(response).to have_http_status(:unauthorized)
    end

    it 'does not create impressions' do
      expect { request }.not_to(change { Impression.count })
    end
  end

  describe 'PATCH :id' do
    let(:request) { process :update, method: :patch, params: params }
    let(:params)  { { id: impression.id, impression: { amount: 13.0 } } }
    context 'given a impression' do
      let(:impression) { create :impression }
      describe 'sending [id,amount]' do
        it 'requires authentication' do
          request
          expect(response).to have_http_status(:unauthorized)
        end

        it 'keeps the impression as it is' do
          impression
          expect { request }.not_to(change { Impression.first.amount })
        end
      end
    end
  end

  describe 'DELETE :id' do
    let(:request) { process :destroy, method: :delete, params: params }
    let(:params)  { { id: impression.id } }
    context 'given a impression' do
      let(:impression) { create :impression }
      describe 'sending [id]' do
        it 'requires authentication' do
          request
          expect(response).to have_http_status(:unauthorized)
        end

        it 'keeps the impression as it is' do
          impression
          expect { request }.not_to(change { Impression.count })
        end
      end
    end
  end
end
