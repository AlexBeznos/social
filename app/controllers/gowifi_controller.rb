class GowifiController < ApplicationController
  layout 'gowifi'
  before_action :find_and_save_place, only: :show
  before_action :find_customer_session_from_device, only: :show
  before_action :set_default_format, only: :show
  before_action :set_locale, only: :show
  before_filter :check_for_place_activation, only: :show
  after_action :ahoy_track_visit, only: [:show]

  skip_after_action :verify_authorized

  def show
    @auths = @place.auths.active.where(step: Auth.steps[current_customer_session.auth_step])
    @banner = find_banner if @place.display_other_banners
    @banner.increment!(:number_of_views) if @banner
  end

  private
  def find_and_save_place
    @place = Place.find_by_slug(params[:slug])
    raise ActiveRecord::RecordNotFound unless @place

    current_customer_session.update(place: @place)
  end

  def device
    Device.create_on_absence(mac_address: params[:mac]) if params[:mac]
  end

  def find_customer_session_from_device
    session =  Customer::Session.find_by(device: device, place: @place)

    if params[:mac] && session
      current_customer_session.destroy
      set_customer_session_cookie(session.id)
    end
  end

  def check_device_remembering

  end

  # we add slug to session to make sure
  # place slug  will be saved in omniauth or at least session

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
