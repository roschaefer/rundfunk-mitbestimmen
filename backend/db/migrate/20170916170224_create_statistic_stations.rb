class CreateStatisticStations < ActiveRecord::Migration[5.0]
  def change
    create_view :statistic_stations
  end
end
