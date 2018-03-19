class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :alternative_names
      t.string :label
      t.string :sublabel

      t.timestamps
    end
  end
end
