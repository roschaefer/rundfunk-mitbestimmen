class AddTemporalExtensionToImpressions < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'btree_gist' unless extension_enabled?('btree_gist')
    change_table :impressions, temporal: true, copy_data: true
  end
end
