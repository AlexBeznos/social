class StocksController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :through => :place

  def index
    @stocks = Stock.where(place_id: @place.id)
  end

  def new
  end

  def create
    @stock.place = @place

    if @stock.save
      redirect_to place_stocks_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.stocks.class'))
    else
      render :action => :new
    end
  end

  def update
    if @stock.update(stock_params)
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

    def stock_params
      params.require(:stock).permit(:url, :image)
    end

end
