require 'rails_helper'

RSpec.describe SelectionsController, type: :controller do
  describe 'POST index' do
    let(:broadcast) { create :broadcast }
    let(:user) { create :user }
    let(:params) do
      {
        selection: {
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

    it 'does not create selections' do
      expect { request }.not_to(change { Selection.count })
    end
  end

  describe 'PATCH :id' do
    let(:request) { process :update, method: :patch, params: params }
    let(:params)  { { id: selection.id, selection: { amount: 13.0 } } }
    context 'given a selection' do
      let(:selection) { create :selection }
      describe 'sending [id,amount]' do
        it 'requires authentication' do
          request
          expect(response).to have_http_status(:unauthorized)
        end

        it 'keeps the selection as it is' do
          selection
          expect { request }.not_to(change { Selection.first.amount })
        end
      end
    end
  end

  describe 'DELETE :id' do
    let(:request) { process :destroy, method: :delete, params: params }
    let(:params)  { { id: selection.id } }
    context 'given a selection' do
      let(:selection) { create :selection }
      describe 'sending [id]' do
        it 'requires authentication' do
          request
          expect(response).to have_http_status(:unauthorized)
        end

        it 'keeps the selection as it is' do
          selection
          expect { request }.not_to(change { Selection.count })
        end
      end
    end
  end
end
