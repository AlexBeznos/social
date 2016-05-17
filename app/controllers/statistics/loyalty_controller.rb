class Statistics::LoyaltyController < ApplicationController

  before_action :set_place

  def show
    authorize :loyalty_statistics
    authorize @place

    @orders = OrderDecorator.decorate_multiple(place_orders(@place))

  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def place_orders(place)
    orders_by_date = if params[:from] && params[:to]
                       Order.created_in_peroid(
                         from: params[:from],
                         to: params[:to]
                       )
                     elsif params[:this_month]
                       Order.created_this_month
                     elsif params[:today]
                       Order.created_today
                     else
                       Order.created_this_week
                     end

    orders_by_date.includes(:customer).where(place: place)
  end
end
