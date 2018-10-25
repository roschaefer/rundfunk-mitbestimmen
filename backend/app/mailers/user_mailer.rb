class UserMailer < ApplicationMailer
  def auth0_migration(user)
    @user = user
    mail(to: @user.email, subject: 'Auth0 Migration')
  end

  def notify_broadcast_creators_on_broadcast_creation
    broadcast_creators = Broadcast.where.not(creator_id: nil).pluck(:creator_id)
    broadcast_creators.each do |broadcast_creator|
      @user = User.find(broadcast_creator)
      mail(to: @user.email, subject: 'A broadcast has been created')
    end
  end
end
