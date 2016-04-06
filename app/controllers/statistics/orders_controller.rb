class Statistics::OrdersController < ApplicationController

  before_action :set_place

  skip_after_action :verify_authorized

  def index
    @items = MenuItemDecorator.decorate_multiple(MenuItem.includes(:orders))

  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

end
