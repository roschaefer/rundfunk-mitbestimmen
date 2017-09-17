class Statistic::BroadcastsController < ApplicationController
  load_and_authorize_resource

  def index
    page = (statistics_params[:page] || 1).to_i
    per_page = (statistics_params[:per_page] || 10).to_i
    order_params = {}
    # TODO: is there a better way to do this with strong params?
    column = Statistic::Broadcast.column_names.include?(statistics_params[:column]) ? statistics_params[:column] : :total
    direction = %w[asc desc].include?(statistics_params[:direction]) ? statistics_params[:direction] : :desc
    order_params.store(column, direction)

    @statistics = Statistic::Broadcast.order(order_params).order(title: :asc).page(page).per(per_page)
    render json: @statistics, meta: { total_pages: @statistics.total_pages }
  end

  def statistics_params
    params.permit(:column, :direction, :page, :per_page)
  end
end
