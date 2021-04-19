class UserMailer < ApplicationMailer
  def auth0_migration(user)
    @user = user
    mail(to: @user.email, subject: 'Auth0 Migration')
  end

  def monthly_news(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('user_mailer.monthly_news.subject'))
  end
end
