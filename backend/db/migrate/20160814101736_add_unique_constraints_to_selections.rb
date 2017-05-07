class AddUniqueConstraintsToSelections < ActiveRecord::Migration[5.0]
  def change
    add_index :selections, %i(user_id broadcast_id), unique: true
  end
end
