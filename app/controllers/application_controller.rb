class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :current_user_session, :current_user, :gen_root_path, :wifi_login_path
  protect_from_forgery with: :null_session
  before_action :check_locale
  before_action :set_timezone

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      target = if (request.referer.nil? || request.url == request.referer || request.method == 'POST')
                 places_path
               else
                 request.referer
               end

      redirect_to target, alert: exception.message
    else
      redirect_to login_path, :alert => exception.message
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
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

    def set_timezone
      tz = current_user ? current_user.timezone : nil
      Time.zone = tz || ActiveSupport::TimeZone['Kyiv']
    end

    def wifi_login_path
      "http://172.16.16.1/login?user=#{@place.wifi_username}&password=#{@place.wifi_password}"
    end

end
