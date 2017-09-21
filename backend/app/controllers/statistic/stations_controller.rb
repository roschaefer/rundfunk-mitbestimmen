module Statistic
  class StationsController < ApplicationController
    load_and_authorize_resource
    def index
      @stations = Statistic::Station.order(:name)
      @stations = filter(@stations)
      render json: @stations
    end

    def show
      @station = Statistic::Station.find(params[:id])
      render json: @station
    end

    private

    def filter(stations)
      filter_params = params[:filter]
      return stations unless filter_params
      stations = stations.where(medium_id: filter_params[:medium_id]) if filter_params[:medium_id]
      stations
    end
  end
end
