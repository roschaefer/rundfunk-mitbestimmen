class AddFixedToSelection < ActiveRecord::Migration[5.0]
  def change
    add_column :selections, :fixed, :boolean
  end
end
