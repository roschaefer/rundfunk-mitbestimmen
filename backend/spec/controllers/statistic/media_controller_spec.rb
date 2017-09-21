require 'rails_helper'

RSpec.describe Statistic::MediaController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      medium = create(:medium)
      get :show, params: { id: medium.to_param }
      expect(response).to have_http_status(:success)
    end
  end
end
