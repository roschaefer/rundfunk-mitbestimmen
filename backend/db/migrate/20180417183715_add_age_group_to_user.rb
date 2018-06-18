class AddAgeGroupToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age_group, :datetime
  end
end
