class CreateSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :selections do |t|
      t.integer :response
      t.decimal :amount
      t.references :user, foreign_key: true
      t.references :broadcast, foreign_key: true

      t.timestamps
    end
  end
end
