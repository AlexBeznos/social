class MenuItemsController < ApplicationController
  before_action :set_place
  before_action :set_menu_item, except: [:index, :new, :create]

  def index
    authorize MenuItem

    @menu_items = @place.menu_items.pagination(params[:page])
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
      redirect_to place_menu_items_path(@place), notice: I18n.t('notice.create', subject: t('menu_item.goods'))
    else
      render action: :new
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
end
