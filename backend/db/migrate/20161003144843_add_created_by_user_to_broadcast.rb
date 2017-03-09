class AddCreatedByUserToBroadcast < ActiveRecord::Migration[5.0]
  def change
    add_column :broadcasts, :creator_id, :integer, index: true
    add_foreign_key :broadcasts, :users, column: :creator_id
  end
end
