class CreateBroadcasts < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcasts do |t|
      t.string :title
      t.string :description
      t.references :topic, foreign_key: true
      t.references :format, foreign_key: true

      t.timestamps
    end
  end
end
