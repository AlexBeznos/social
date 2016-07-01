class GowifiController < ApplicationController
  layout 'gowifi'
  before_action :find_place, only: :show
  before_action :set_place_slug, only: :show
  before_action :set_default_format, only: :show
  before_action :set_locale, only: :show
  before_action :check_device_remembering, only: :show
  before_filter :check_for_place_activation, only: :show
  after_action :ahoy_track_visit, only: [:show]

  skip_after_action :verify_authorized

  def show
    @auths = @place.auths.active.where(step: current_customer_session.auth_step)
    @banner = find_banner if @place.display_other_banners
    @banner.increment!(:number_of_views) if @banner
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:slug])
    raise ActiveRecord::RecordNotFound unless @place
  end

  def device
    Device.create_on_absence(mac_address: params[:mac]) if params[:mac]
  end

  def set_device
    current_customer_session.update_on_unequality(
      device_id: device.id,
    ) if device
  end

  # we add slug to session to make sure
  # place slug  will be saved in omniauth or at least session

  def set_place_slug
    current_customer_session.update_on_unequality(
      place: @place
    )
  end


  def check_device_remembering
    if current_customer_session.place && current_customer_session.device_remembered?
      current_customer_session.update_on_unequality(
        auth_step: "secondary"
      )
    end

    #NOTE: for what this used ?
    # return if session[:auth_step] == 'secondary' && @place.mfa
    # session[:auth_step] = 'primary'
  end

  def set_default_format
    request.format = :html
  end

  def set_locale
    I18n.locale = if params[:lang] && I18n.available_locales.include?(params[:lang].to_sym)
                    params[:lang]
                  elsif @place.auth_default_lang.present?
                    @place.auth_default_lang
                  end

    session[:locale] = I18n.locale
  end

  # TODO: make banner injection by simple method and visits incrementation by ajax call
  def find_banner
    values = {
      left_border: @place.longitude-0.2,
      right_border: @place.longitude+0.2,
      top_border: @place.latitude+0.2,
      bottom_border: @place.latitude-0.2,
      self_id: @place.id
    }

    Banner.where(place_id: Place.where('latitude > :bottom_border and latitude < :top_border
                                        and longitude > :left_border and longitude < :right_border
                                        and id != :self_id and display_my_banners = true',
                                        values)).sample
  end

  def check_for_place_activation
    redirect_to wifi_login_path(@place, "http://#{request.host}") unless @place.try(:active)
  end
end
