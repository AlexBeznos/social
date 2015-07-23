class MenuItemsController < ApplicationController
  layout false
  before_action :find_place, only: :index
  before_action :find_customer, only: [:index, :taken_items]
  before_action :load_reputation_score, only: :index

  def index
    @menu_items = MenuItem.where(place_id: @place.id)
  end

  def taken_items
    @taken_menu_items = @customer.menu_items
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def load_reputation_score
      @reputation = Customer::Reputation.find_by(place_id: @place.id, customer_id: @customer.id)
      @reputation_score = @reputation.nil? ? 0 : @reputation.score
    end
end
