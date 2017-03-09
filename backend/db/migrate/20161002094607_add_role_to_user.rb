class AddRoleToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :integer, default: 0, index: true
  end
end
