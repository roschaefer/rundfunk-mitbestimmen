class AddUniqueConstraintToSchedule < ActiveRecord::Migration[5.1]
  def change
     add_index :schedules, [:broadcast_id, :station_id], unique: true
  end
end
