class ApplicationController < ActionController::API
  include Knock::Authenticable
  include CanCan::ControllerAdditions
  check_authorization

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || request.headers['locale'] || I18n.default_locale
  end

  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  def authenticate_user
    user = authenticate_for(User)
    if user
      user.update_location(request.location) unless user.location?
      user
    else
      unauthorized_entity('user')
    end
  end
end
