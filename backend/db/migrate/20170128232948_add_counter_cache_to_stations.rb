class AddCounterCacheToStations < ActiveRecord::Migration[5.0]
  def change
    change_table :stations do |t|
      t.integer :broadcasts_count, default: 0
    end

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE stations
           SET broadcasts_count = (SELECT count(1)
                                   FROM broadcasts
                                  WHERE broadcasts.station_id = stations.id)
    SQL
  end
end
