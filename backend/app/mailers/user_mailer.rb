class UserMailer < ApplicationMailer
  def auth0_migration(user)
    @user = user
    mail(to: @user.email, subject: 'Auth0 Migration')
  end

  def monthly_news(user, _reason)
    @user = user
    mail(to: @user.email, subject: '')
  end
end
