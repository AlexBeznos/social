class StylesController < ApplicationController
  before_action :icons_save, only: [:create, :update]
  before_action :set_style , except: [:new , :create]
  before_action :set_place

  def new
    authorize Style

    @style = Style.new
  end

  def create
    authorize Style

    @style = Style.new(permitted_attributes(Style))
    @style.place = @place

    if @style.save
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.style.class'))
    else
      render :action => :new
    end
  end

  def edit
    authorize @style
  end

  def update
    authorize @style

    if @style.update(permitted_attributes(Place))
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.style.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @style

    @style.destroy
    redirect_to settings_place_path(@place)
  end

  private

    def set_place
      @place = Place.find_by_slug(params[:place_id])
    end

    def set_style
      @style = Style.find(params[:id])
    end

    def icons_save
      params[:style][:network_icons].each do |network, record|
        SocialNetworkIcon.create(record)
      end

      params[:style].delete(:network_icons)
    end
end
