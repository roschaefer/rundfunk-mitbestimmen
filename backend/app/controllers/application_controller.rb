class ApplicationController < ActionController::API
  include Knock::Authenticable
  include CanCan::ControllerAdditions
  check_authorization

  before_action :set_paper_trail_whodunnit
  before_action :set_locale

  def set_locale
    update_user_locale
    I18n.locale = current_user ? current_user.locale : guest_locale
  end

  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  private

  def update_user_locale
    locale = request.headers['locale']
    locale ||= params[:locale]
    locale ||= params[:data][:attributes][:locale]
    if current_user && locale && %w(en de).include?(locale)
      current_user.update_locale!(locale)
      current_user.locale.reload
    end
  rescue
    #ignore
  end

  def guest_locale
    params[:locale] || request.headers['locale'] || I18n.default_locale
  end
end
