class StocksController < ApplicationController
  before_filter :require_user
  before_action :find_place
  before_action :find_stock, except: [:index, :new, :create]
  before_filter :require_proper_user

  def index
    @stocks = Stock.where(place_id: @place.id)
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(message_params)
    @stock.place_id = @place.id

    if @stock.save
      redirect_to place_stocks_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.stocks.class'))
    else
      render :action => :new
    end
  end

  def update
    if @stock.update(message_params)
      redirect_to place_stocks_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.stocks.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    @stock.destroy
    redirect_to place_stocks_path(@place)
  end

  private
    def find_place
      @place = Place.find_by_slug(params[:place_id])
    end

    def find_stock
      @stock = Stock.find(params[:id])
    end

    def message_params
      params.require(:stock).permit(:url, :image)
    end

end
