class UpdateStatisticBroadcastsToVersion3 < ActiveRecord::Migration[5.0]
  def change
    drop_view :statistic_stations, revert_to_version: 1
    drop_view :statistic_media, revert_to_version: 1
    drop_view :statistic_medium_translations, revert_to_version: 1
    drop_view :statistic_broadcasts, revert_to_version: 2
    create_view :statistic_broadcasts
    update_view :statistic_broadcasts, revert_to_version: 1, version: 3
    create_view :statistic_stations
    create_view :statistic_media
    create_view :statistic_medium_translations
  end
end
