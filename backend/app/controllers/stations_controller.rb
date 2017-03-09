class StationsController < ApplicationController
  before_action :set_station, only: [:show]
  load_and_authorize_resource

  # GET /stations
  def index
    @stations = Station.all

    render json: @stations
  end

  # GET /stations/1
  def show
    render json: @station
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end
end
