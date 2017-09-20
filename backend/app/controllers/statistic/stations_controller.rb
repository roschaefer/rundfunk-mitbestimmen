module Statistic
  class StationsController < ApplicationController
    load_and_authorize_resource
    def index
      @stations = Statistic::Station.where(medium_id: params[:medium_id]).order(:name)
      render json: @stations
    end

    def show
      @station = Statistic::Station.find(params[:id])
      render json: @station
    end
  end
end
