class MenuItemsController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource

  skip_authorize_resource :only => :welcome
  skip_authorize_resource :place, :only => :welcome

  before_action :find_customer, only: :welcome
  before_action :load_reputation_score, only: :welcome

  def index
    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
  end

  def welcome

    @menu_items = MenuItem.where(place_id: @place.id).pagination(params[:page])
    render :layout => 'loyalty_program'
  end

  def new
  end

  def create
    @menu_item.place_id = @place.id

    if @menu_item.save
      redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.create', subject: t('menu_item.goods'))
    else
      render :action => :new
    end
  end

    def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.updated', subject: t('menu_item.goods'))
    else
      render :action => :edit
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to place_menu_items_path(@place), :notice => I18n.t('notice.deleted', subject: t('menu_item.goods'))
  end

  private

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

    def menu_item_params
      params.require(:menu_item).permit(:name, :description, :price, :image)
    end
end
