class StatisticsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :summarized

  def summarized
    # fake the model
    render json: {
      data: {
        id: 1,
        type: 'summarized-statistics',
        attributes: {
          'broadcasts' => Broadcast.count,
          'registered-users' => User.count,
          'impressions' => Impression.count,
          'assigned-money' => Statistic::Broadcast.sum(:total)
        }
      }
    }
  end
end
