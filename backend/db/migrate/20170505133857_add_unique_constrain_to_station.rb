class AddUniqueConstrainToStation < ActiveRecord::Migration[5.0]
  def change
    add_index :stations, :name, unique: true
  end
end
