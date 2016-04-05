class Statistics::OrdersController < ApplicationController

  before_action :set_place

  skip_after_action :verify_authorized

  def index
    @orders = Order.where(place: @place)
    @items = MenuItem.joins(:orders).where(place: @place)
  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

end
