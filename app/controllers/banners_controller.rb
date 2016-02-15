class BannersController < ApplicationController
  before_action :set_place
  before_action :set_banner, except: [:index, :new, :create]
  before_action :check_city, except: [:index]

  def index
    authorize Banner

    @banners = @place.banners
  end

  def new
    authorize Banner
    @banner = @place.banners.new
  end

  def edit
    authorize @banner
  end


  def create
    authorize Banner

    @banner = Banner.new(permitted_attributes(Banner))
    @banner.place_id = @place.id

    if @banner.save
      redirect_to place_banners_path(:notice => I18n.t('notice.create', subject: I18n.t('models.banners.class')))
    else
      render :action => :new
    end
  end

  def update
    authorize @banner

    if @banner.update(permitted_attributes(Banner))
      redirect_to place_banners_path(:notice => I18n.t('notice.updated', subject: I18n.t('models.banners.class')))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @banner

    @banner.destroy
    respond_to do |format|
      format.html { redirect_to place_banners_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.banners.class')) }
    end
  end

  private
    def set_place
      @place = Place.find_by_slug(params[:place_id])
    end

    def set_banner
      @banner = Banner.find(params[:id])
    end


    def check_city
      if !@place.city?
        redirect_to place_banners_path
      end
    end
end
