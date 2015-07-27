class MenuItemsController < ApplicationController
  layout false
  before_action :find_place, only: [:index, :buy_item, :taken_items]
  before_action :find_customer, only: [:index, :taken_items, :buy_item]
  before_action :load_menu_item, only: :buy_item
  before_action :load_reputation_score, only: [:index, :buy_item]

  def index
    @menu_items = MenuItem.where(place_id: @place.id)
  end

  def taken_items
    @orders = @customer.orders.pagination(params[:page])
  end

  def buy_item
    created = @menu_item.create_order(@reputation, @customer)
    redirect_to menu_items_list_path, notice: t('menu_item.not_enough_points') unless created
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

    def load_menu_item
      @menu_item = MenuItem.find(params[:id])
    end
end
