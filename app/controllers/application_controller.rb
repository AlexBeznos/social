class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :current_user_session, :current_user, :gen_root_path
  protect_from_forgery with: :null_session
  before_action :check_locale

  def require_user
    unless current_user
      no_access_to_login
    end
  end

  def require_proper_user
    unless current_user.get_all_places.include?(@place)
      no_access_to_place
    end
  end

  def no_access_to_login
    redirect_to login_path, alert: 'You have no rights to access this page!'
  end

  def no_access_to_place
    redirect_to places_path, alert: 'You have no rights to access this page!'
  end


  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def gen_root_path(user = false)
      u = user ? user : current_user

      if u
        if u.general? || u.franchisee?
          return places_path
        elsif u.admin?
          return adm_root_path
        end
      else
        root_path
      end
    end

    def check_locale
      if !session[:locale] || !I18n.available_locales.include?(session[:locale].to_sym)
        locale = http_accept_language.compatible_language_from(I18n.available_locales)
        if locale && I18n.available_locales.include?(locale.to_sym)
          I18n.locale = locale
          session[:locale] = locale
        else
          session[:locale] = I18n.default_locale
        end
      else
        I18n.locale = session[:locale]
      end
    end

end
