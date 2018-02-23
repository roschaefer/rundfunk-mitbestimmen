class UniqueConstraintOnSimilarities < ActiveRecord::Migration[5.1]
  def change
    add_index :similarities, [:broadcast1_id, :broadcast2_id], unique: true
  end
end
