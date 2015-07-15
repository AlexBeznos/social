class GowifiController < ApplicationController
  include Consumerable
  layout false
  before_action :find_place, only: [:show, :enter_by_password, :redirect_after_auth]
  before_action :find_place_from_session, only: :omniauth
  before_action :find_customer, only: [:show, :omniauth]
  before_filter :check_for_place_activation, only: :show
  skip_before_action :verify_authenticity_token, only: :show

  def show
    @networks = @place.get_networks
    @stock = Stock.where(place_id: @place.id).order("RANDOM()").first
    @message = @place.messages.active.where(social_network: 2).first

    respond_to do |format|
      format.html
      format.css
      format.js
    end
  end

  def enter_by_password
    if @place.enter_by_password && @place.password == params[:password] && create_visit_by_password(@place)
      redirect_to wifi_login_path
    else
      redirect_to gowifi_place_path @place
    end
  end

  def omniauth
    unless visit_already_created?
      AdvertisingWorker.perform_async(session[:slug], credentials, edited_message_params)
    end

    clear_session
    redirect_to wifi_login_path
  end

  def auth_failure
    if params[:provider]
      redirect_to "/auth/#{params[:provider]}"
    else
      redirect_to gowifi_place_path(:slug => session[:slug])
    end
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

    def find_place_from_session
      @place = Place.find_by_slug(request.env['omniauth.params']['place'])
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def check_for_place_activation
      return redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.try(:active)
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


    def visit_already_created?
      hash = find_or_create_costumer(credentials, @place, @customer)
      cookies.permanent[:customer] = hash[:customer].id

      hash[:visit]
    end

    def edited_message_params
      #params.require(:message).permit(:message, :message_link, :image)
    end

end
