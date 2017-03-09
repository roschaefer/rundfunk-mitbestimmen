class BalancesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :condensed

  def index
    page = (balances_params[:page] || 1).to_i
    per_page = (balances_params[:per_page] || 10).to_i
    order_params = {}
    # TODO: is there a better way to do this with strong params?
    column = Balance.column_names.include?(balances_params[:column]) ? balances_params[:column] : :total
    direction = ['asc', 'desc'].include?(balances_params[:direction]) ? balances_params[:direction] : :desc
    order_params.store(column, direction)

    @balances = Balance.order(order_params).order(title: :asc).page(page).per(per_page)
    render json: @balances, meta: {total_pages: @balances.total_pages}
  end


  def condensed
    # fake the model
    render json: {
      data: {
        id: params[:id],
        type: 'condensed-balances',
        attributes: {
          "broadcasts" => Broadcast.count,
          "registered-users" => User.count,
          "reviews" => Selection.count,
          "assigned-money" => Balance.sum(:total)
        }
      }
    }
  end


  def balances_params
    params.permit(:column, :direction, :page, :per_page)
  end
end
