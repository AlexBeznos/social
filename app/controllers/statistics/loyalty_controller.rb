class Statistics::LoyaltyController < ApplicationController

  before_action :set_place

  def show
    authorize @place

    @orders = OrderDecorator.decorate_multiple(place_orders(@place))
  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def place_orders(place)
    orders_by_date = if bool_params[:from] && bool_params[:to]
                       Order.created_in_peroid(
                         from: params[:from],
                         to: params[:to]
                       )
                     elsif bool_params[:this_month]
                       Order.created_this_month
                     elsif bool_params[:today]
                       Order.created_today
                     else
                       Order.created_this_week
                     end

    orders_by_date.includes(:customer).where(place: place)
  end

  def bool_params
    bool_par = {}
    
    %i{today from to this_month this_week}.each do |date|
      if params[date]
        begin
          bool_par[date] = params[date].to_bool
        rescue ArgumentError
          d = Date.parse(params[date]) rescue nil
          d ? bool_par[date] = true : bool_par[date] = false
        end
      else
        bool_par[date] = false
      end
    end
    bool_par
  end

end
