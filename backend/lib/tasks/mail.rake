namespace :mail do
  desc 'Send an explanation for the migration to auth0 and tell them to reset their password'

  task auth0_migration: :environment do
    User.find_each do |user|
      UserMailer.auth0_migration(user).deliver_now
    end
  end
end
