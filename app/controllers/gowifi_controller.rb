class GowifiController < ApplicationController
  include Consumerable
  layout 'no-layout'
  before_action :find_place, only: [:show, :enter_by_password, :redirect_after_auth]
  before_action :find_customer, only: [:show, :omniauth]
  before_filter :check_for_place_activation, only: :show

  def show
    session[:slug] = @place.slug
    @networks = @place.get_networks
  end

  def enter_by_password
    if @place.enter_by_password && @place.password == params[:password] && create_visit_by_password(@place)
      redirect_to 'http://172.16.16.1/login?user=P8uDratA&password=Tac4edrU'
    end
  end

  def omniauth
    @place = Place.find_by_slug(session[:slug])
    @message = get_message(@place, credentials['provider'])

    clear_session

    post_advertisment
    deal_with_customer

    redirect_to 'http://172.16.16.1/login?user=P8uDratA&password=Tac4edrU'
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

    redirect_to request.referrer
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
      redirect_to '/404.html' if !@place || !@place.active
    end

    def credentials
      request.env['omniauth.auth']
    end

    def clear_session
      session.delete(:slug)
    end

    def post_advertisment
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
