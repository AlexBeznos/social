class StocksController < ApplicationController
  before_action :set_place
  before_action :set_stock , only: [:update , :destroy , :edit]

  after_action :verify_policy_scoped
  after_action :verify_authorized

  def index
    if policy_scope(Place).include?(@place)
      authorize @place , :show?
      authorize Stock
      @stocks = Stock.where(place_id: @place.id)
    end
  end

  def new
    if policy_scope(Place).include?(@place)
      authorize Stock
      @stock = Stock.new
    end
  end

  def create
    if policy_scope(Place).include?(@place)
      authorize @place ,:update?
      authorize Stock

      @stock = Stock.new(permitted_attributes(Stock))
      @stock.place = @place

      if @stock.save
        redirect_to place_stocks_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.stocks.class'))
      else
        render :action => :new
      end
    end
  end

  def edit
    if policy_scope(Place).include?(@place)||policy_scope(Stock).include?(@stock)
      authorize @place ,:update?
      authorize Stock
    end
  end

  def update
    if policy_scope(Place).include?(@place)||policy_scope(Stock).include?(@stock)
      authorize @place ,:update?
      authorize @stock

      if @stock.update(permitted_attributes(Stock))
        redirect_to place_stocks_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.stocks.class'))
      else
        render :action => :edit
      end
    end
  end

  def destroy
    if policy_scope(Place).include?(@place)||policy_scope(Stock).include?(@stock)
      authorize @place ,:update?
      authorize @stock

      @stock.destroy
      redirect_to place_stocks_path(@place)
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_place
    @place = Place.find_by(slug:params[:place_id])
  end

end
