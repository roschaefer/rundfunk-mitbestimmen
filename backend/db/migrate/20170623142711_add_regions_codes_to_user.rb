class AddRegionsCodesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :country_code, :string
    add_column :users, :state_code, :string
    add_column :users, :postal_code, :string
    add_column :users, :city, :string
  end
end
