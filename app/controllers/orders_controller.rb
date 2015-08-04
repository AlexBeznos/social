class OrdersController < ApplicationController
  layout 'loyalty_program'

  before_action :find_place
  before_action :find_customer
  before_action :load_reputation_score
  before_action :load_menu_item, except: :index

  def index
    @orders = @customer.orders.pagination(params[:page])
  end

  def show
  end

  def create
    @order = @place.orders.create(customer_id: @customer.id)

    if @order.add_menu_item(@reputation, @menu_item)
      @reputation_score = @reputation.score
      redirect_to action: :show
    else
      redirect_to menu_items_list_path, notice: t('menu_item.not_enough_points')
    end
  end

  private

    def find_customer
      if cookies[:customer]
        @customer = Customer.find(cookies[:customer].to_i)
      else
        redirect_to gowifi_place_path(@place)
      end
    end

    def find_place
      @place = Place.find_by_slug(params[:place_id])
    end

    def load_reputation_score
      @reputation = Customer::Reputation.find_by(place_id: @place.id, customer_id: @customer.id)
      @reputation_score = @reputation.nil? ? 0 : @reputation.score
    end

    def load_menu_item
      @menu_item = MenuItem.find(params[:id])
    end


end