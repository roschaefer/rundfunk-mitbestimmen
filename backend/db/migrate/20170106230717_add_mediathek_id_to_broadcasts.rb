class AddMediathekIdToBroadcasts < ActiveRecord::Migration[5.0]
  def change
    add_column :broadcasts, :mediathek_identification, :integer
    add_index :broadcasts, :mediathek_identification, :unique => true
  end
end
