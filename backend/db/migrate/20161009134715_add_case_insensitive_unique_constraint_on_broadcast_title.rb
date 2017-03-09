class AddCaseInsensitiveUniqueConstraintOnBroadcastTitle < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    drop_view :balances, revert_to_version: 5
    change_column :broadcasts, :title, :citext
    create_view :balances, version: 5
  end
end
