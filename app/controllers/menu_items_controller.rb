class MenuItemsController < ApplicationController
  before_action :set_place
  before_action :set_menu_item, except: [:index, :welcome, :new, :create]
  before_action :find_customer, only: :welcome
  before_action :load_reputation_score, only: :welcome

  def index
    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
  end

  def welcome
    skip_authorization

    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
    render :layout => 'loyalty_program'
  end

  def new
    authorize MenuItem
    @menu_item = MenuItem.new
  end

  def create
    authorize MenuItem

    @menu_item = MenuItem.new(permitted_attributes(MenuItem))
    @menu_item.place_id = @place.id

    if @menu_item.save
      redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.create', subject: t('menu_item.goods'))
    else
      render :action => :new
    end
  end

  def edit
    authorize @menu_item
  end

  def update
    authorize @menu_item

    if @menu_item.update(permitted_attributes(MenuItem))
      redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.updated', subject: t('menu_item.goods'))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @menu_item

    @menu_item.destroy
    redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.deleted', subject: t('menu_item.goods'))
  end

  private
  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def find_customer
    if cookies[:customer]
      @customer = Customer.find(cookies[:customer].to_i)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  def load_reputation_score
    @reputation = Customer::Reputation.find_by(place_id: @place.id, customer_id: @customer.id)
    @reputation_score = @reputation.nil? ? 0 : @reputation.score
  end
end
