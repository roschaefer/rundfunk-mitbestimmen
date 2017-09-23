class ApplicationController < ActionController::API
  include Knock::Authenticable
  include CanCan::ControllerAdditions
  check_authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_locale

  def set_locale
    update_user_locale
    locale = current_user ? current_user.locale : false
    I18n.locale = params[:locale] || request.headers['locale'] || locale || I18n.default_locale
  end

  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  private

  def update_user_locale
    locale = params[:locale]
    if current_user && locale && %w(en de).include?(locale)
      current_user.update_attribute(:locale, locale)
    end
  end
end
