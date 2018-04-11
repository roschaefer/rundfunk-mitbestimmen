class DropScheduleIdFromBroadcasts < ActiveRecord::Migration[5.1]
  def change
    remove_column :broadcasts, :schedule_id
  end
end
