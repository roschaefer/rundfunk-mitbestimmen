class UpdateStatisticBroadcastsToVersion3 < ActiveRecord::Migration[5.0]
  def change
    drop_view :statistic_stations, revert_to_version: 1
    drop_view :statistic_media, revert_to_version: 1
    update_view :statistic_broadcasts, version: 3, revert_to_version: 2
    create_view :statistic_stations
    create_view :statistic_media
  end
end
