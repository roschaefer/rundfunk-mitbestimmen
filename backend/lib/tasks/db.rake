namespace :db do
  desc 'replace user sensitive data with placeholders'
  task anonymize_user: :environment do
    if ENV['RAILS_ENV'] == 'production'
      puts 'You do not want to anonymize production data'
    else
      puts 'Anonymizing user data'

      User.find_each do |user|
        user.encrypted_password = user.encrypted_password.truncate(8)
        user.latitude = 50 + 0.001 * user.id
        user.longitude = 10 - 0.001 * user.id
        user.city = "city#{user.id}"

        user.email = "user#{user.id}@example.org"
        user.save!
      end
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
