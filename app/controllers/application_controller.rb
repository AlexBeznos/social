 class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  helper_method :current_user_session, :current_user, :current_customer, :gen_root_path, :wifi_login_path
  protect_from_forgery with: :null_session
  before_action :check_locale
  before_action :set_timezone

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      target = if (request.referer.nil? || request.url == request.referer || request.method == 'POST')
                 places_path
               else
                 request.referer
               end

      redirect_to target, alert: t('pundit.default')
    else
      redirect_to login_path, alert: t('pundit.default')
    end
  end

rescue_from ActiveRecord::RecordNotFound do |exception|
  redirect_to '/404.html'
end


  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    payload[:visit_id] = ahoy.visit_id # if you use Ahoy
  end

  def customer_cookie
    cookies.permanent[:customer]
  end

  def customer_cookie=(customer)
    cookies.permanent[:customer] = customer
  end

  def current_customer
    @customer ||= if customer_cookie
      Customer.find(customer_cookie)
    end
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

    def ahoy_track_visit
      ahoy.track_visit
    end

    def ahoy_authenticate
      current_visit.try(:update, { customer: current_customer })
    end

    def gen_root_path(user = false)
      u = user ? user : current_user
      return places_path if u

      root_path
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

    def wifi_login_path(place, url)
      return url if place.demo
      router = place.router
      "http://172.16.16.1/login?user=#{router.hp_username}&password=#{router.hp_password}&dst=#{url}"
    end

end
