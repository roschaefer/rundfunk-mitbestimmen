class UpdateStatisticBroadcastsToVersion4 < ActiveRecord::Migration[5.0]
  def change
    drop_view :statistic_stations, revert_to_version: 1
    drop_view :statistic_media, revert_to_version: 1
    drop_view :statistic_medium_translations, revert_to_version: 1
    drop_view :statistic_broadcasts, revert_to_version: 2
    create_view :statistic_broadcasts, materialized: true
    update_view :statistic_broadcasts, revert_to_version: 1, version: 4, materialized: true
    create_view :statistic_stations
    create_view :statistic_media
    create_view :statistic_medium_translations
    add_index :statistic_broadcasts, :id, unique: true
  end
end
