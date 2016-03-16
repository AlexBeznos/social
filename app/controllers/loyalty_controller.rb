class LoyaltyController < ApplicationController
  before_action :find_place
  before_action :find_customer
  before_action :find_auth
  before_action :load_reputation_score

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

  def find_customer
    if cookies[:customer]
      @customer = Customer.find(cookies[:customer].to_i)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  def find_auth
    return redirect_to root_path unless params[:auth]
    @auth = Auth.find(params[:auth])
  end

  def load_reputation_score
    @reputation = Customer::Reputation.find_by(place_id: @place.id, customer_id: @customer.id)
    @reputation_score = @reputation.nil? ? 0 : @reputation.score
  end
end
