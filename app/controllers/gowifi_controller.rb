class GowifiController < ApplicationController
  include Consumerable

  layout false
  before_action :find_place, only: :show
  before_action :find_customer, only: :show
  before_filter :check_for_place_activation, only: :show

  def show
    @networks = @place.get_networks
    @stock = Stock.where(place_id: @place.id).order("RANDOM()").first

    respond_to do |format|
      format.html
      format.css
      format.js
    end
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def check_for_place_activation
      return redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.try(:active)
    end
end
