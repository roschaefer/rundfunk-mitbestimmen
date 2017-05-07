class SelectionsController < ApplicationController
  before_action :set_selection, only: %i(show update destroy)
  before_action :authenticate_user
  load_and_authorize_resource

  def index
    @selections = current_user.selections
    if params[:filter] && params[:filter][:response] == 'positive'
      @selections = @selections.positive
    end
    render json: @selections, include: :broadcast
  end

  # GET /selections/1
  def show
    render json: @selection
  end

  # POST /selections
  def create
    @selection = Selection.new(selection_params)
    @selection.user = current_user # you can only create your own

    if @selection.save
      render json: @selection, status: :created, location: @selection
    else
      render json: @selection.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /selections/1
  def update
    if @selection.update(selection_params)
      render json: @selection
    else
      render json: @selection.errors, status: :unprocessable_entity
    end
  end

  # DELETE /selections/1
  def destroy
    @selection.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_selection
    @selection = Selection.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def selection_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i(amount response fixed broadcast))
  end
end
