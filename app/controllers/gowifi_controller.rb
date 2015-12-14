class GowifiController < ApplicationController
  include Consumerable

  layout false
  before_action :find_place, only: :show
  before_action :set_place_slug, only: :show
  before_action :find_customer, only: :show
  before_filter :check_for_place_activation, only: :show

  def show
    @networks = @place.get_networks
    @banner = find_banner if @place.display_other_banners
    @banner.increment!(:number_of_views) if @banner
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    # we add slug to session to make sure
    # place slug  will be saved in omniauth or at least session
    def set_place_slug
      session[:slug] = @place.slug
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
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
      return redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.try(:active)
    end
end
