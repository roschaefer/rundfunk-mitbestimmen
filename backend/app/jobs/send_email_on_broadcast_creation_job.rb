class SendEmailOnBroadcastCreationJob < ApplicationJob
  queue_as :default

  def perform
    UserMailer.notify_broadcast_creators_on_broadcast_creation.deliver_later
  end
end
