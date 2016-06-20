class GowifiAuthController < ApplicationController
  after_action :set_auth_step
  skip_after_action :verify_authorized

  protected

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def succed_auth_path(place, auth)
    if place.mfa && session[:auth_step] == 'primary'
      return gowifi_place_path(@place)
    end

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
