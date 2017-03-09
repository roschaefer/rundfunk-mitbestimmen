class AddUniqueConstraintsToSelections < ActiveRecord::Migration[5.0]
  def change
    add_index :selections, [:user_id, :broadcast_id], :unique => true
  end
end
