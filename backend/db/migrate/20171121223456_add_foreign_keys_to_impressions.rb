class AddForeignKeysToImpressions < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key 'temporal.impressions', :broadcasts
    add_foreign_key 'temporal.impressions', :users

    change_column_null :impressions, :broadcast_id, false
    change_column_null :impressions, :user_id, false
    change_column_null :impressions, :response, false
  end
end
