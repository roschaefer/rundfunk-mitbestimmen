namespace :db do
  desc 'replace user sensitive data with placeholders'
  task anonymize_user: :environment do
    if ENV['RAILS_ENV'] == 'production'
      puts 'You do not want to anonymize production data'
    else
      puts 'Anonymizing user data'

      @user_ids = User.ids.shuffle
      Broadcast.find_each do |broadcast|
        broadcast.creator_id = @user_ids.sample
        broadcast.save!
      end
      User.find_each do |user|
        new_id = @user_ids.pop
        user.encrypted_password = user.encrypted_password.truncate(8)
        user.auth0_uid = user.auth0_uid.truncate(15) + new_id.to_s if user.auth0_uid
        user.latitude = 50 + 0.001 * new_id
        user.longitude = 10 - 0.001 * new_id
        user.city = "city#{new_id}"
        user.postal_code = 10000 + new_id

        user.email = "user#{new_id}@example.com"
        user.save!
      end
      Rake::Task['db:dump'].invoke
    end
  end

  desc 'Dumps the database to db/APP_NAME.dump'
  task dump: :environment do
    app, host, db, user = with_config
    cmd = "pg_dump --host #{host} #{user_present?(user)} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    puts cmd
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task restore: :environment do
    app, host, db, user = with_config
    cmd = "pg_restore --verbose --host #{host} #{user_present?(user)} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    #TODO does not work
    Rails.env = 'development'
    Rake::Task['db:environment:set'].invoke
    puts cmd
    exec cmd
  end

  private

  def user_present?(user)
    user ? '--username ' + user : nil
  end

  def with_config
    [
      Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
    ]
  end
end
