class BroadcastsController < ApplicationController
  before_action :set_broadcast, only: %i[show update destroy]
  before_action :authenticate_user, except: %i[index show]
  load_and_authorize_resource

  # GET /broadcasts
  def index
    sort = params[:sort] || 'asc'
    @broadcasts = Broadcast.search(query: params[:q],
                                   filter_params: params[:filter],
                                   sort: sort, seed: params[:seed],
                                   user: current_user)

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    @broadcasts = @broadcasts.page(page).per(per_page)
    mark_broadcasts_as_seen(@broadcasts)
    render json: @broadcasts, scope: current_user, include: params[:include], meta: { total_count: @broadcasts.total_count, total_pages: @broadcasts.total_pages }
  end

  # GET /broadcasts/1
  def show
    mark_broadcasts_as_seen([@broadcast])
    render json: @broadcast
  end

  # POST /broadcasts
  def create
    @broadcast = Broadcast.new(broadcast_params)
    @broadcast.creator = current_user

    if @broadcast.save
      # TODO: notify all moderators and admins here
      UserMailer.ask_for_spam_check(@broadcast.id, User.last.id).deliver_later
      render json: @broadcast, status: :created, location: @broadcast
    else
      render json: @broadcast, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # PATCH/PUT /broadcasts/1
  def update
    if @broadcast.update(broadcast_params)
      render json: @broadcast
    else
      render json: @broadcast, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # DELETE /broadcasts/1
  def destroy
    @broadcast.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_broadcast
    @broadcast = Broadcast.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def broadcast_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[title description image-url broadcast-url medium stations])
  end

  def mark_broadcasts_as_seen(broadcasts)
    return unless current_user

    new_broadcasts = broadcasts - current_user.broadcasts
    current_user.broadcasts << new_broadcasts
  end
end
