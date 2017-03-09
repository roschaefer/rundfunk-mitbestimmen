class AddAuth0UidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth0_uid, :string, index: true
    # TODO: avoid null values
  end
end
