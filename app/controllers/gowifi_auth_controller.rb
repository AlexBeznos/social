class GowifiAuthController < ApplicationController
  include Consumerable

  before_action :find_place, only: [:enter_by_password, :enter_by_sms, :simple_enter, :redirect_after_auth, :submit_poll]
  before_action :find_customer, only: [:omniauth, :redirect_after_auth]
  before_action :find_place_from_session, only: [:omniauth, :auth_failure]

  skip_after_action :verify_authorized

  def enter_by_password
    if @place.enter_by_password && @place.password == params[:password] && create_visit_by_password(@place)
      redirect_to wifi_login_path
    else
      redirect_to gowifi_place_path @place
    end
  end

  def enter_by_sms
    sms = @place.gowifi_sms.where(code: params[:code])

    if sms.any?
      sms.first.destroy
      render json: { url: wifi_login_path }, status: :ok
    else
      render json: { error: I18n.t('wifi.sms_try_more').humanize }, status: :unprocessable_entity
    end
  end

  def simple_enter

    if @place.simple_enter
      redirect_to wifi_login_path
    else
      redirect_to gowifi_place_path @place
    end
  end

  def submit_poll

    if params[:poll]
      @answer = Answer.find(poll_params[:answer_ids])
      if @answer.increment!(:number_of_selections)
        redirect_to wifi_login_path
      else
        redirect_to gowifi_place_path @place
      end
    else
      redirect_to :back, alert: I18n.t('wifi.poll_error')
    end
  end

  def omniauth
    unless visit_already_created?
      AdvertisingWorker.perform_async(@place.slug, credentials)
    end

    clear_session
    redirect_to wifi_login_path
  end

  def auth_failure
    if params[:provider]
      redirect_to "/auth/#{params[:provider]}"
    else
      redirect_to gowifi_place_path(:slug => @place.slug)
    end
  end

  def redirect_after_auth
        if @place
      if @place.loyalty_program && @customer
        redirect_to menu_items_list_path(@place)
      else
        redirect_to @place.redirect_url
      end
    else
      redirect_to root_path
    end
  end

  private
    def poll_params
      params.require(:poll).permit(:answer_ids)
    end

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def find_place_from_session
      @place = Place.find_by_slug(request.env['omniauth.params']['place'] || session[:slug])
    end

    def credentials
      request.env['omniauth.auth']
    end

    def clear_session
      session.delete(:slug)
    end

    def visit_already_created?
      hash = find_or_create_costumer(credentials, @place, @customer)
      cookies.permanent[:customer] = hash[:customer].id

      hash[:visit]
    end
end
