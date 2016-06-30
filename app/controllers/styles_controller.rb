class StylesController < ApplicationController
  before_action :set_style, except: [:new, :create]
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

    if @style.update(permitted_attributes(Style))
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
end
