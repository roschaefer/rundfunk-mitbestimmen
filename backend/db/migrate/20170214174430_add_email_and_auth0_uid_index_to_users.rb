class AddEmailAndAuth0UidIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true
    add_index :users, :auth0_uid, unique: true
  end
end
