class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.references :artist
      t.timestamp :aired
      t.string :station

      t.timestamps
    end
  end
end
