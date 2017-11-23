class UpdateChronoModelMetaData < ActiveRecord::Migration[5.1]
  def change
    drop_view :statistic_stations, revert_to_version: 1
    drop_view :statistic_media, revert_to_version: 1
    drop_view :statistic_medium_translations, revert_to_version: 1
    remove_index :statistic_broadcasts, :id
    drop_view :statistic_broadcasts, materialized: true

    ActiveRecord::Base.connection.chrono_setup!

    create_view :statistic_broadcasts, materialized: true
    update_view :statistic_broadcasts, revert_to_version: 5, version: 5, materialized: true
    add_index :statistic_broadcasts, :id, unique: true
    create_view :statistic_stations
    create_view :statistic_media
    create_view :statistic_medium_translations
  end
end
