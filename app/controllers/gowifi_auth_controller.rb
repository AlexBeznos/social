class GowifiAuthController < ApplicationController
  before_action :find_place, only: [:enter_by_password, :enter_by_sms, :simple_enter, :submit_poll]
  before_action :find_place_from_session, only: [:omniauth, :auth_failure]
  before_action :find_auth, only: :omniauth
  before_action :find_or_create_customer, only: :enter_by_password
  before_action :check_facebook_permissions, only: :omniauth
  after_action :ahoy_track_visit, only: [:enter_by_password, :enter_by_sms, :simple_enter, :submit_poll]
  after_action :ahoy_authenticate, only: [:omniauth]


  skip_after_action :verify_authorized

  def enter_by_password
    auth = @place.auths.active.find_by({ resource_type: PasswordAuth, step: Auth.steps[cookies[:step]] })

    if auth && auth.resource.password == params[:password]
      profile = Profile.create_with_resource({provider: 'password'}, @customer)
      Customer::Visit.create(
        place: @place,
        account_id: profile.resource_id,
        account_type: profile.resource_type,
        customer: profile.customer
      )
      redirect_to succed_auth_path(@place, auth)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  def enter_by_sms
    sms = SmsProfile.find_by(code: params[:code])
    auth = @place.auths.active.find_by({ resource_type: SmsAuth, step: Auth.steps[cookies[:step]] })

    if sms && sms.update(used: true)
      Customer::Visit.create(
        place: @place,
        account_id: sms.profile.resource_id,
        account_type: sms.profile.resource_type,
        customer: sms.profile.customer
      )
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
      auth = Auth.find(params[:poll_auth][:id])
      answer = Answer.find(poll_params[:answer_ids])

      if answer.increment!(:number_of_selections)
        redirect_to succed_auth_path(@place, auth)
      else
        redirect_to gowifi_place_path(@place)
      end
    else
      redirect_to :back, alert: I18n.t('wifi.poll_error')
    end
  end

  def omniauth
    decorator = NetworksAuthDecorator.new(
      credentials: credentials,
      auth: @auth,
      place: @place,
      customer_id: customer_cookie
    )

    decorator.save
    session.delete(:slug)
    send('customer_cookie=', decorator.customer.id)

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

  def find_or_create_customer
    if customer_cookie
      @customer = Customer.find(customer_cookie.to_i)
    else
      @customer = Customer.create
      customer_cookie = @customer.id
    end
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
      cookies.delete(:step)

      url = if @place.loyalty_program && current_customer && auth.network?
        loyalty_url(@place, auth: auth.id)
      else
        auth.redirect_url
      end

      wifi_login_path(place, url)
    end
  end

  def credentials
    request.env['omniauth.auth']
  end

  def clear_session
    session.delete(:slug)
  end

  def check_facebook_permissions
    if credentials['provider'] == 'facebook' && !FacebookService.publishing_permitted?(credentials['credentials']['token'])
      redirect_to gowifi_place_path(@place), alert: 'Error'
    end
  end
end
