class UpdateStatisticBroadcastsToVersion2 < ActiveRecord::Migration[5.0]
  def change
    drop_view :statistic_stations, revert_to_version: 1
    update_view :statistic_broadcasts, version: 2, revert_to_version: 1
    create_view :statistic_stations
  end
end
