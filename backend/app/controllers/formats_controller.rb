class FormatsController < ApplicationController
  before_action :set_format, except: :index
  load_and_authorize_resource

  # GET /formats
  def index
    @formats = Format.all

    render json: @formats
  end

  # GET /formats/1
  def show
    render json: @format
  end

  private

  def set_format
    @format = Format.find(params[:id])
  end
end
