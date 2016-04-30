class Statistics::LoyaltyController < ApplicationController

  before_action :set_place

  def show
    authorize @place
    @items = MenuItemDecorator.decorate_multiple(@place.menu_items)

    @profiles = 

  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end
end
