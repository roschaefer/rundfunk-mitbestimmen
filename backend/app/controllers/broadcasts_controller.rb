class BroadcastsController < ApplicationController
  before_action :set_broadcast, only: %i[show update destroy]
  before_action :authenticate_user, except: [:index]
  load_and_authorize_resource

  # GET /broadcasts
  def index
    @broadcasts = Broadcast.all.includes(:selections)

    @broadcasts = @broadcasts.search_by_title(params[:q]) if params[:q].present?

    filter_params = params[:filter]
    if filter_params

      if filter_params[:medium].present?
        @broadcasts = @broadcasts.where(medium: filter_params[:medium])
      end

      if filter_params[:station].present?
        @broadcasts = @broadcasts.where(station_id: filter_params[:station])
      end

      if current_user && filter_params[:review] == 'reviewed'
        reviewed_broadcasts
      end

      if current_user && filter_params[:review] == 'unreviewed'
        unreviewed_broadcasts
      end
    end

    @broadcasts = if params[:sort] == 'random'
                    broadcasts_randomly_ordered
                  else
                    @broadcasts.order(title: :asc) # induce unique sort order for pagination
                  end

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    @broadcasts = @broadcasts.page(page).per(per_page)

    render json: @broadcasts, scope: current_user, meta: { total_count: @broadcasts.total_count, total_pages: @broadcasts.total_pages }
  end

  # GET /broadcasts/1
  def show
    render json: @broadcast
  end

  # POST /broadcasts
  def create
    @broadcast = Broadcast.new(broadcast_params)
    @broadcast.creator = current_user

    if @broadcast.save
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
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[title description medium station])
  end

  def reviewed_broadcasts
    @broadcasts = current_user.broadcasts.includes(:selections)
  end

  def unreviewed_broadcasts
    @broadcasts = @broadcasts.unevaluated(current_user)
  end

  def broadcasts_randomly_ordered
    if params[:seed]
      clamp_seed = [params[:seed].to_f, -1, 1].sort[1] # seed is in [-1, 1]
      query = Broadcast.send(:sanitize_sql, ['select setseed( ? )', clamp_seed])
      Broadcast.connection.execute(query)
    end
    @broadcasts.order('RANDOM()')
  end
end
