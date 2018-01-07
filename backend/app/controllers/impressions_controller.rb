class ImpressionsController < ApplicationController
  before_action :set_impression, only: %i[show update destroy]
  before_action :authenticate_user
  load_and_authorize_resource

  def index
    @impressions = current_user.impressions
    @impressions = @impressions.positive if params[:filter] && params[:filter][:response] == 'positive'
    render json: @impressions, include: :broadcast
  end

  # GET /impressions/1
  def show
    render json: @impression
  end

  # POST /impressions
  def create
    @impression = Impression.new(impression_params)
    @impression.user = current_user # you can only create your own

    if @impression.save
      render json: @impression, status: :created, location: vote_url(@impression)
    else
      render json: @impression.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /impressions/1
  def update
    if @impression.update(impression_params)
      render json: @impression
    else
      render json: @impression.errors, status: :unprocessable_entity
    end
  end

  # DELETE /impressions/1
  def destroy
    @impression.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_impression
    @impression = Impression.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def impression_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[amount response fixed broadcast])
  end
end
