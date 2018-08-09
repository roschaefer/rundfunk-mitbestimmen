class ReplaceStateCodeWithState < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :state_code, :state
    User.update_all('country_code = lower(country_code)')
    user_relation = User.where.not(auth0_uid: nil)

    puts "About to geocode #{user_relation.count} users"
    user_relation.find_each do |user|
      GeocodeUserJob.perform_later(user.auth0_uid)
    end
  end
end
