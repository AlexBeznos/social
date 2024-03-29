class LoyaltyController < ApplicationController
  before_action :find_place
  before_action :authenticate_customer
  before_action :find_auth
  before_action :find_reputation

  layout 'loyalty_program'

  def index
    @menu_items = @place.menu_items.pagination(params[:page])
    skip_authorization
  end

  private

  def find_place
    return redirect_to root_path unless params[:place_id]
    @place = Place.find_by_slug(params[:place_id])
  end

  def authenticate_customer
    redirect_to root_path unless current_customer
  end

  def find_auth
    return redirect_to root_path unless params[:auth]
    @auth = Auth.find(params[:auth])
  end

  def find_reputation
    @reputation = Customer::Reputation.find_by(
      place_id: @place.id,
      customer_id: current_customer.id
    ) || Customer::Reputation.new
  end
end
