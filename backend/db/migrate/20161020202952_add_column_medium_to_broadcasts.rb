class AddColumnMediumToBroadcasts < ActiveRecord::Migration[5.0]
  def change
    add_column :broadcasts, :medium, :integer, default: 0
  end
end
