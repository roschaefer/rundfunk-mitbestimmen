module Statistic
  class MediaController < ApplicationController
    load_and_authorize_resource
    def index
      @media = Statistic::Medium.order(:name)
      render json: @media
    end

    def show
      @medium = Statistic::Medium.find(params[:id])
      render json: @medium
    end
  end
end
