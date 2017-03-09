class AddBadEmailFlatToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_bad_email, :boolean, default: false

    User.find_each do |user|
      if ValidEmail2::Address.new(user.email).disposable?
        user.has_bad_email = true
        user.save!
      end
    end
  end
end
