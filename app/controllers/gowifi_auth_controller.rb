class GowifiAuthController < ApplicationController
  include Consumerable

  before_action :find_place, only: [:enter_by_password, :enter_by_sms, :simple_enter, :submit_poll]
  before_action :find_customer, only: :omniauth
  before_action :find_place_from_session, only: [:omniauth, :auth_failure]
  before_action :find_auth, only: :omniauth
  before_filter :check_facebook_permissions, only: :omniauth

  skip_after_action :verify_authorized

  def enter_by_password
    auth = @place.auths.active.find_by({ resource_type: PasswordAuth, step: Auth.steps[cookies[:step]] })

    if auth && auth.resource.password == params[:password] && create_visit_by_password(@place)
      redirect_to succed_auth_path(@place, auth)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  def enter_by_sms
    sms = @place.gowifi_sms.find_by(code: params[:code])
    auth = @place.auths.active.find_by({ resource_type: SmsAuth, step: Auth.steps[cookies[:step]] })

    if sms && create_visit_by_sms(@place)
      sms.destroy
      redirect_to succed_auth_path(@place, auth)
    else
      redirect_to gowifi_sms_confirmation_path(@place, params[:id]), alert: I18n.t('wifi.sms_try_more')
    end
  end

  def simple_enter
    auth = @place.auths.active.find_by({ resource_type: SimpleAuth, step: Auth.steps[cookies[:step]] })

    if auth
      redirect_to succed_auth_path(@place, auth)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  def submit_poll
    if params[:poll_auth]
      answer = Answer.find(poll_params[:answer_ids])

      if answer.increment!(:number_of_selections)
        redirect_to succed_auth_path(@place, answer.poll_auth.auth)
      else
        redirect_to gowifi_place_path(@place)
      end
    else
      redirect_to :back, alert: I18n.t('wifi.poll_error')
    end
  end

  def omniauth
    unless visit_already_created?
      AdvertisingWorker.perform_async(
        @place.slug,
        @auth.id,
        redis_ready_credentials(credentials)
      )
    end

    clear_session
    redirect_to succed_auth_path(@place, @auth)
  end

  def auth_failure
    if params[:provider]
      redirect_to "/auth/#{params[:provider]}"
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  private
  def poll_params
    params.require(:poll_auth).permit(:answer_ids)
  end

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def find_customer
    @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
  end

  def find_place_from_session
    slug_by_omni = request.env.try(:[], 'omniauth.params').try(:[], 'place')
    slug_by_session = session[:slug]

    @place = Place.find_by_slug(slug_by_omni || slug_by_session)
  end

  def find_auth
    @auth = @place.auths
      .active
      .resource_like(credentials['provider'].capitalize)
      .where(step: Auth.steps[cookies[:step]])
      .first
  end

  def succed_auth_path(place, auth)
    if place.mfa && cookies[:step] == 'primary' && auth.step == 'primary'
      cookies[:step] = 'secondary'

      gowifi_place_path(place)
    else
      if @place.scratchcard? && auth.network?
        scratchcard_path(@place, auth_id: auth.id)
      else
        wifi_login_path(place, login_url(@place, auth, @customer))
      end
    end
  end

  def credentials
    request.env['omniauth.auth']
  end

  def clear_session
    session.delete(:slug)
  end

  def visit_already_created?
    hash = find_or_create_customer(credentials, @place, @customer)
    cookies.permanent[:customer] = hash[:customer].id

    hash[:visit]
  end

  def check_facebook_permissions
    if credentials['provider'] == 'facebook' && !FacebookService.publishing_permitted?(credentials['credentials']['token'])
      redirect_to gowifi_place_path(@place), alert: 'Error'
    end
  end
end
