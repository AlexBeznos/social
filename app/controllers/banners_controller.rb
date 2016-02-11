  class BannersController < ApplicationController
  load_and_authorize_resource :place, find_by: :slug
  load_and_authorize_resource :banner, through: :place

  before_action :set_place
  before_action :set_banner , except: [:index, :new, :create]
  before_action :check_city, except: [:index]

  after_action :verify_authorized , :verify_policy_scoped

  def index
    authorize @place , :show?
    authorize Banner

    if policy_scope(Place).include?(@place)
      @banners = @place.banners
    end
  end

  def new
    authorize @place , :show?
    authorize Banner
    if policy_scope(Place).include?(@place)
      @banner = @place.banners.new
    end
  end

  def edit
    if policy_scope(Place).include?(@place) && policy_scope(Place).include?(@place)
      authorize @place , :show?
      authorize @banner
    end
  end

  def create
    authorize @place , :update?
    authorize Banner

    if policy_scope(Place).include?(@place)
      @banner = @place.banners.new(permitted_attributes(Banner))

      if @banner.save
        redirect_to place_banners_path(:notice => I18n.t('notice.create', subject: I18n.t('models.banners.class')))
      else
        render :action => :new
      end
    end
  end

  def update
    authorize @place , :update?
    authorize @banner

    if policy_scope(Place).include?(@place) && policy_scope(Place).include?(@place)
      if @banner.update(permitted_attributes(Banner))
        redirect_to place_banners_path(:notice => I18n.t('notice.updated', subject: I18n.t('models.banners.class')))
      else
        render :action => :edit
      end
    end
  end

  def destroy
    authorize @place , :update?
    authorize @banner

    if policy_scope(Place).include?(@place) && policy_scope(Place).include?(@place)
      @banner.destroy

      respond_to do |format|
        format.html { redirect_to place_banners_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.banners.class')) }
      end
    end
  end

  private
    def set_place
      @place = Place.find_by(slug: params[:user_id])
    end

    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    def check_city
      if !@place.city?
        redirect_to place_banners_path
      end
    end
end
