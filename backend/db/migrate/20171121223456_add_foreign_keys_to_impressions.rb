class AddForeignKeysToImpressions < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key 'temporal.impressions', :broadcasts
    add_foreign_key 'temporal.impressions', :users

    change_column_null 'temporal.impressions', :broadcast_id, false
    change_column_null 'temporal.impressions', :user_id, false
  end
end
