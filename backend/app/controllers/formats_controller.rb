class FormatsController < ApplicationController
  before_action :set_format, only: %i(show update destroy)
  before_action :authenticate_user
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

  # POST /formats
  def create
    @format = Format.new(format_params)

    if @format.save
      render json: @format, status: :created, location: @format
    else
      render json: @format.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /formats/1
  def update
    if @format.update(format_params)
      render json: @format
    else
      render json: @format.errors, status: :unprocessable_entity
    end
  end

  # DELETE /formats/1
  def destroy
    @format.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_format
    @format = Format.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def format_params
    params.require(:format).permit(:name)
  end
end
