class AddForeignKeysToImpressions < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :impressions, :broadcasts
    add_foreign_key :impressions, :users

    change_column_null :impressions, :broadcast_id, false
    change_column_null :impressions, :user_id, false
  end
end
