class AddImageUrlToBroadcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :broadcasts, :image_url, :string
  end
end
