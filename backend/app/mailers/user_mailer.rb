class UserMailer < ApplicationMailer
  def auth0_migration(user)
    @user = user
    mail(to: @user.email, subject: 'Auth0 Migration')
  end
end
