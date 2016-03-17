class StocksController < ApplicationController
  before_action :set_place
  before_action :set_stock, only: [:update, :destroy, :edit]

  def index
    authorize Stock

    @stocks = Stock.where(place_id: @place.id)
  end

  def new
    authorize Stock

    @stock = Stock.new
  end

  def create
    authorize Stock

    @stock = Stock.new(permitted_attributes(Stock))
    @stock.place = @place

    if @stock.save
      redirect_to place_stocks_path(@place), notice: I18n.t('notice.create', subject: I18n.t('models.stocks.class'))
    else
      render :action => :new
    end
  end

  def edit
    authorize @stock
  end

  def update
    authorize @stock

    if @stock.update(permitted_attributes(Stock))
      redirect_to place_stocks_path(@place), notice: I18n.t('notice.updated', subject: I18n.t('models.stocks.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @stock

    @stock.destroy
    redirect_to place_stocks_path(@place)
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

end
