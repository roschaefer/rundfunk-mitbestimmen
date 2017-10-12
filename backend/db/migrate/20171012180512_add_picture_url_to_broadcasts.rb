class AddPictureUrlToBroadcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :broadcasts, :picture_url, :string
  end
end
