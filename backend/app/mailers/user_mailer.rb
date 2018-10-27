class UserMailer < ApplicationMailer
  after_action :prevent_delivery_to_bad_email_addresses

  def prevent_delivery_to_bad_email_addresses
    mail.perform_deliveries = false if @user.has_bad_email? || @user.email.blank?
  end

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

  def ask_for_spam_check(broadcast_id, moderator_id)
    @user = User.find(moderator_id)
    @broadcast = Broadcast.find(broadcast_id)
    mail(to: @user.email, subject: "A broadcast \"#{@broadcast.title}\" has been created")
  end
end
