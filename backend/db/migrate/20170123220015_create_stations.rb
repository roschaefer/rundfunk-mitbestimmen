class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.references :medium, foreign_key: true

      t.timestamps
    end
  end
end
