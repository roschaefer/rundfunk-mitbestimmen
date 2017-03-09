require 'rails_helper'

RSpec.describe "Stations", type: :request do
  describe "GET /stations" do
    it "works! (now write some real specs)" do
      get stations_path
      expect(response).to have_http_status(200)
    end
  end
end
