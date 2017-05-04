class GowifiAuthController < ApplicationController
  after_action :set_auth_step
  skip_after_action :verify_authorized

  protected

  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def succed_auth_path(place, auth)
    if place.mfa && current_customer_session.auth_step == 'primary'
      return gowifi_place_path(@place)
    end

    url = if place.loyalty_program && current_customer_session.customer && auth.network?
      loyalty_url(place, auth: auth.id)
    else
      auth.redirect_url
    end

    wifi_login_path(place, url)
  end

  private

  def set_auth_step
    if @place.mfa? && @auth.step == "primary"
      current_customer_session.update_on_unequality(
        auth_step: "secondary"
      )
    else
      current_customer_session.update_on_unequality(
        auth_step: "primary"
      )
    end
  end
end
