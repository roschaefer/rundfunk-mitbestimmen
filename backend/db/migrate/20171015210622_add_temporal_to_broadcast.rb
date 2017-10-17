class AddTemporalToBroadcast < ActiveRecord::Migration[5.1]
  def self.up
    enable_extension 'btree_gist' unless extension_enabled?('btree_gist')
    change_table :broadcasts, temporal: true, copy_data: true, :journal => %w( approval )
  end

  def self.down
    change_table :broadcasts, temporal: false
  end
end
