class CreateSimilarities < ActiveRecord::Migration[5.1]
  def change
    create_table :similarities do |t|
      t.integer :broadcast1_id
      t.integer :broadcast2_id
      t.decimal :value

      t.timestamps
    end
  end
end
