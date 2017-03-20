class AddUniqueIndexToBroadcastTitle < ActiveRecord::Migration[5.0]
  def change
    add_index :broadcasts, :title, unique: true
  end
end
