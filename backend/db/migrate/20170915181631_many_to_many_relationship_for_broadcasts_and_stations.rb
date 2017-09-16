class ManyToManyRelationshipForBroadcastsAndStations < ActiveRecord::Migration[5.1]
  def up
    create_table :schedules do |t|
      t.belongs_to :broadcast, index: true
      t.belongs_to :station, index: true
      t.timestamps
    end

    execute <<-SQL
          INSERT INTO schedules (broadcast_id, station_id, created_at, updated_at)
          SELECT id AS broadcast_id, station_id, created_at, updated_at
          FROM broadcasts
          WHERE station_id IS NOT NULL;
    SQL

    remove_column :broadcasts, :station_id, :integer
    add_reference :broadcasts, :schedule, index: true
    add_foreign_key :broadcasts, :schedules
  end

  def down
    raise activeRecord::IrreversibleMigration
  end
end
