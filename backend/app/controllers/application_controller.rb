class ApplicationController < ActionController::API
  include Knock::Authenticable
  include CanCan::ControllerAdditions
  check_authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_locale
  before_action :set_raven_context
  before_action :set_last_login

  def set_locale
    I18n.locale = user_locale || guest_locale
  end

  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  private

  def guest_locale
    params[:locale] || request.headers['locale'] || I18n.default_locale
  end

  def user_locale
    current_user&.locale
  end

  def set_last_login
    if current_user
      current_user.touch
    end
  end

  def set_raven_context
    Raven.user_context(id: current_user.id) if current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
