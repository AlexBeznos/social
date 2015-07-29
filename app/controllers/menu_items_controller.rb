class MenuItemsController < ApplicationController
  layout false, only: [:index, :taken_items, :buy_item]

  load_and_authorize_resource :place, :find_by => :slug, except: [:index, :taken_items, :buy_item]
  load_and_authorize_resource except: [:index, :taken_items, :buy_item]

  before_action :find_place, only: [:index, :taken_items, :buy_item, :manage_items]
  before_action :find_customer, only: [:index, :taken_items, :buy_item]
  before_action :load_menu_item, only: :buy_item
  before_action :load_reputation_score, only: [:index, :buy_item, :taken_items]

  def index
    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
  end

  def new
  end

  def create
    @menu_item.place_id = @place.id

    if @menu_item.save
      redirect_to manage_menu_items_path(@place), :notice => I18n.t('notice.create', subject: t('menu_item.goods'))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to manage_menu_items_path(@place), :notice => I18n.t('notice.updated', subject: t('menu_item.goods'))
    else
      render :action => :edit
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to settings_place_path(@place), :notice => I18n.t('notice.deleted', subject: t('menu_item.goods'))
  end

  def taken_items
    @orders = @customer.orders.pagination(params[:page])
  end

  def buy_item
    created = @menu_item.create_order(@reputation, @customer)
    redirect_to menu_items_list_path, notice: t('menu_item.not_enough_points') unless created
    @reputation_score = @reputation.score
  end

  def manage_items
    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    def find_customer
      if cookies[:customer]
        @customer = Customer.find(cookies[:customer].to_i)
      else
        redirect_to gowifi_place_path
      end
    end

    def load_reputation_score
      @reputation = Customer::Reputation.find_by(place_id: @place.id, customer_id: @customer.id)
      @reputation_score = @reputation.nil? ? 0 : @reputation.score
    end

    def load_menu_item
      @menu_item = MenuItem.find(params[:id])
    end

    def menu_item_params
      params.require(:menu_item).permit(:name, :description, :price, :image)
    end
end
