class StylesController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :through => :place, :singleton => true
  before_action :icons_save, only: [:create, :update]

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)
    @style.place = @place

    if @style.save
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.style.class'))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @style.update(style_params)
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.style.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    @style.destroy
    redirect_to settings_place_path(@place)
  end

  private

    def style_params
      params.require(:style).permit(
                                    :background,
                                    :text_color,
                                    :greating_color,
                                    :css,
                                    :network_icons)
    end

    def icons_save
      params[:style][:network_icons].each do |network, record|
        SocialNetworkIcon.create(record)
      end

      params[:style].delete(:network_icons)
    end


end
