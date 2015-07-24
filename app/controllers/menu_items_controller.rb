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
    @orders = @customer.orders.order('created_at DESC').page(params[:page]).per(3)
  end

  def buy_item
    if @reputation.score >= @menu_item.price
      @reputation.update(score: @reputation.score - @menu_item.price)
      @customer.menu_items << @menu_item
    else
      redirect_to menu_items_list_path, notice: "No money, bitch!"
    end
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
