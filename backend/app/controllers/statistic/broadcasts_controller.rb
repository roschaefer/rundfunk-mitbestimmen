module Statistic
  class BroadcastsController < ApplicationController
    load_and_authorize_resource
    before_action :set_statistic_broadcast, only: %i[show temporal]

    def show
      @statistic_broadcast = Statistic::Broadcast.find_broadcast_as_of(@broadcast, Time.zone.parse(params[:as_of])) if params[:as_of]
      render json: @statistic_broadcast
    end

    def temporal
      from = if params[:from]
               Time.zone.parse(params[:from])
             else
               3.months.ago
             end
      to = if params[:to]
             Time.zone.parse(params[:to])
           else
             Time.zone.now
           end
      nth_day = params[:day] || 7
      nth_day = nth_day.to_i

      range = [from]
      new_date = from + nth_day.days
      while new_date < to
        range << new_date
        new_date += nth_day.days
      end
      range << to

      range = range.map { |t| [t, Statistic::Broadcast.find_broadcast_as_of(@broadcast, t)] }
      render json: range.map { |t, statistic| [t, statistic.total] }
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
