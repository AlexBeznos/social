class Statistics::LoyaltyController < ApplicationController

  before_action :set_place

  def show
    authorize @place
    # @items = MenuItemDecorator.decorate_multiple(MenuItem
    #                                               .includes(:orders)
    #                                               .where(place: @place)
    #                                             )

    @orders = OrderDecorator.decorate_multiple(Order
                                                .includes(:customer)
                                                .where(place: @place)
                                              )

  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end
end
