class GowifiController < ApplicationController
  include Consumerable

  layout false
  before_action :find_place, only: [:show, :enter_by_poll, :submit_poll]
  before_action :set_place_slug, only: :show
  before_action :find_customer, only: :show
  before_filter :check_for_place_activation, only: :show

  def show
    @networks = @place.get_networks
    @stock = @place.get_proper_stock
    @poll = @place.polls.sample
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

    def check_for_place_activation
      return redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.try(:active)
    end
end
