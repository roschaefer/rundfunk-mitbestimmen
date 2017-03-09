class ApplicationMailer < ActionMailer::Base
  default from: 'info@rundfunk-mitbestimmen.de'
  layout 'mailer'

  after_action :prevent_delivery_to_bad_email_addresses

  def prevent_delivery_to_bad_email_addresses
    if @user.has_bad_email? || @user.email.blank?
      mail.perform_deliveries = false
    end
  end
end
