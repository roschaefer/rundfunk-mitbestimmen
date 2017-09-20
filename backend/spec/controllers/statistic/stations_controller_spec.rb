require 'rails_helper'

RSpec.describe Statistic::StationsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      medium = create(:medium)
      get :index, params: { medium_id: medium.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      station = create(:station)
      get :show, params: { id: station.to_param }
      expect(response).to have_http_status(:success)
    end
  end

end
