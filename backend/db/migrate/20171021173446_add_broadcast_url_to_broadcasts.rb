class AddBroadcastUrlToBroadcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :broadcasts, :broadcast_url, :string
  end
end
