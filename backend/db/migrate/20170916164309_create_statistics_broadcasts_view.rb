class CreateStatisticsBroadcastsView < ActiveRecord::Migration[5.1]
  def change
    create_view :statistic_broadcasts
  end
end
