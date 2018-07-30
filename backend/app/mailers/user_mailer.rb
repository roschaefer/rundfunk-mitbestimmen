class UserMailer < ApplicationMailer
  def auth0_migration(user)
    @user = user
    mail(to: @user.email, subject: 'Auth0 Migration')
  end

  def monthly_news(user)
    @user = user
    mail(to: @user.email, subject: 'New happenings at Rundfunk Mitbestimmen')
  end
end
