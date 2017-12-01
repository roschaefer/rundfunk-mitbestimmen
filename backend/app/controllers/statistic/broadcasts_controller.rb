module Statistic
  class BroadcastsController < ApplicationController
    load_and_authorize_resource
    before_action :set_statistic_broadcast, only: %i[show]

    def show
      if params[:as_of]
        @statistic_broadcast = Statistic::Broadcast.find_broadcast_as_of(@broadcast, Time.zone.parse(params[:as_of]))
      end
      render json: @statistic_broadcast
    end

    def index
      page = (statistics_params[:page] || 1).to_i
      per_page = (statistics_params[:per_page] || 10).to_i
      # TODO: is there a better way to do this with strong params?
      column = Statistic::Broadcast.column_names.include?(statistics_params[:column]) ? statistics_params[:column] : :total
      order_mapping = {
        'asc' => 'ASC NULLS LAST',
        'desc' => 'DESC NULLS LAST'
      }
      direction = order_mapping[statistics_params[:direction]] || 'DESC NULLS LAST'
      order_by_clause = [column, direction].join(' ')

      @statistics = Statistic::Broadcast.order(order_by_clause).order(title: :asc).page(page).per(per_page)
      render json: @statistics, meta: { total_pages: @statistics.total_pages }
    end

    def statistics_params
      params.permit(:column, :direction, :page, :per_page)
    end

    private
    def set_statistic_broadcast
      @statistic_broadcast = Statistic::Broadcast.find(params[:id])
    end
  end
end
