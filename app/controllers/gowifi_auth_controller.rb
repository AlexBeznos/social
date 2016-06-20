class GowifiAuthController < ApplicationController
  after_action :set_auth_step
  skip_after_action :verify_authorized

  protected

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

<<<<<<< HEAD
  def find_or_create_customer
    if customer_cookie
      @customer = Customer.find(customer_cookie.to_i)
    else
      @customer = Customer.create
      send('customer_cookie=',  @customer.id)
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
=======
  def succed_auth_path(place, auth)
    if place.mfa && session[:auth_step] == 'primary'
      return gowifi_place_path(@place)
    end
>>>>>>> c3b0b764af636e266d37a71533320aeee6186204

    url = if place.loyalty_program && current_customer && auth.network?
      loyalty_url(place, auth: auth.id)
    else
      auth.redirect_url
    end

    wifi_login_path(place, url)
  end

  private

  def set_auth_step
    session[:auth_step] = if @place.mfa && session[:auth_step] == 'primary' && @auth.step == 'primary'
      'secondary'
    else
      'primary'
    end
  end
end
