class GowifiController < ApplicationController
  include Consumerable
  layout 'no-layout'
  before_action :find_place, only: [:show, :enter_by_password, :redirect_after_auth]
  before_action :find_customer, only: [:show, :omniauth]
  before_filter :check_for_place_activation, only: :show

  def show
    session[:slug] = @place.slug
    @networks = @place.get_networks
    @styles_exist = File.directory?("#{Rails.root}/app/assets/stylesheets/wifi/#{@place.slug}")
    @js_exist = File.directory?("#{Rails.root}/app/assets/javascripts/wifi/#{@place.slug}")
    @icons_exist = File.directory?("#{Rails.root}/app/assets/images/wifi/#{@place.slug}")
  end

  def enter_by_password
    if @place.enter_by_password && @place.password == params[:password] && create_visit_by_password(@place)
      redirect_to wifi_login_path
    else
      redirect_to gowifi_place_path @place
    end
  end

  def omniauth
    @place = Place.find_by_slug(session[:slug])

    clear_session

    post_advertisment
    deal_with_customer

    redirect_to wifi_login_path
  end

  def redirect_after_auth
    if @place
      redirect_to @place.redirect_url
    else
      redirect_to root_path
    end
  end

  def set_locale
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end
    redirect = request.referrer

    redirect_to  redirect ||= root_path
  end

  def feedback
    if params[:name] && params[:tel] && params[:email]
      BasicMailer.feedback(params[:name], params[:tel], params[:email]).deliver
      head :ok
    end
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def check_for_place_activation
      redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.active
    end

    def credentials
      request.env['omniauth.auth']
    end

    def clear_session
      session.delete(:slug)
    end

    def wifi_login_path
      "http://172.16.16.1/login?user=#{@place.wifi_username}&password=#{@place.wifi_password}"
    end

    def post_advertisment
      @message = get_message(@place, credentials['provider'])
      attrs = {:place => @place, :message => @message, :credentials => credentials}

      case credentials['provider']
      when 'twitter'
         TwitterService.new(attrs).advertise
      when 'instagram'
         InstagramService.new(attrs).advertise
      when 'vkontakte'
         VkService.new(attrs).advertise
      when 'facebook'
         FacebookService.new(attrs).advertise
      end
    end

    def deal_with_customer
      customer = find_or_create_costumer(credentials, @place, @customer)

      unless @customer
        cookies.permanent[:customer] = customer.id
      end
    end

end
