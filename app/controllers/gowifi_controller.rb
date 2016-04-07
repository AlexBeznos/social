class GowifiController < ApplicationController
  include Consumerable

  layout 'gowifi'
  before_action :find_place, only: :show
  before_action :set_place_slug, only: :show
  before_action :set_step, only: :show
  before_action :set_default_format, only: :show
  before_action :find_customer, only: :show
  before_action :set_locale, only: :show
  before_filter :check_for_place_activation, only: :show
  after_action :ahoy_track_visit, only: [:show]

  skip_after_action :verify_authorized

  def show
    @auths = @place.auths.active.where(step: Auth.steps[cookies[:step]] || 'primary')
    @banner = find_banner if @place.display_other_banners
    @banner.increment!(:number_of_views) if @banner
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:slug])
    raise ActiveRecord::RecordNotFound unless @place
  end

  # we add slug to session to make sure
  # place slug  will be saved in omniauth or at least session
  def set_place_slug
    session[:slug] = @place.slug
  end

  def set_step
    cookies[:step] = {
      value: 'primary',
      expires: 15.minutes.from_now
    } unless cookies[:step]
  end

  def set_default_format
    request.format = :html
  end

  def find_customer
    @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
  end

  def set_locale
    if params[:lang] && I18n.available_locales.include?(params[:lang].to_sym)
      return I18n.locale = params[:lang]
    end

    I18n.locale = @place.auth_default_lang unless @place.auth_default_lang.blank?
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
