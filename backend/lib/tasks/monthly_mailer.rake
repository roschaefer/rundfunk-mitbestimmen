namespace :monthly_mailer do
  desc "Send mail alerting non-active users new happenings on Rundfunk Mitbestimmen"

  task monthly_news: :environment do
    User.find_each do |user|
      UserMailer.monthly_news(user).deliver_now
    end
  end
end
