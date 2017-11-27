module Statistic
  class BroadcastsController < ApplicationController
    load_and_authorize_resource

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
  end
end
