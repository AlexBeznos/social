  class BannersController < ApplicationController
  load_and_authorize_resource :place, find_by: :slug
  load_and_authorize_resource :banner, through: :place

  before_action :set_banner, only: [:edit, :update, :destroy]


  def index
    @banners = @place.banners
  end

  def new
    @banner = @place.banners.new
  end

  def edit
  end

  def create
    @banner = @place.banners.new(banner_params)

    if @banner.save
      redirect_to place_banners_path(:notice => I18n.t('notice.create', subject: I18n.t('models.banners.class')))
    else
      render :action => :new
    end
  end

  def update
    if @banner.update(banner_params)
      redirect_to place_banners_path(:notice => I18n.t('notice.updated', subject: I18n.t('models.banners.class')))
    else
      render :action => :edit 
    end
  end

  def destroy
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to place_banners_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.banners.class')) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banner_params
      params.require(:banner).permit(:name, :content)
    end
  
end
