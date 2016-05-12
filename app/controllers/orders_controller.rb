class OrdersController < ApplicationController
  layout 'loyalty_program'

  before_action :find_place
  before_action :find_auth
  before_action :authenticate_customer
  before_action :find_reputation
  before_action :load_menu_item, except: :index

  skip_after_action :verify_authorized

  def index
    @orders = current_customer.orders.pagination(params[:page])
  end

  def show
  end

  def create
    @order = @place.orders.create(customer_id: current_customer.id)

    if @order.add_menu_item(@reputation, @menu_item)
      @order.set_price!
      render :show
    else
      redirect_to loyalty_path, notice: t('menu_item.not_enough_points')
    end
  end

  private

  def authenticate_customer
    redirect_to gowifi_place_path(@place) unless current_customer
  end

  def find_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def find_auth
    @auth = Auth.find(params[:auth])
  end

  def find_reputation
    @reputation = Customer::Reputation.find_by(
      place_id: @place.id,
      customer_id: current_customer.id
    ) || Customer::Reputation.new
  end

  def load_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
end
