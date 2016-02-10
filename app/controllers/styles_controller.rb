class StylesController < ApplicationController
  # load_and_authorize_resource :place, :find_by => :slug
  # load_and_authorize_resource :through => :place, :singleton => true

  before_action :icons_save, only: [:create, :update]
  before_action :set_style , except: [:new , :create]
  before_action :set_place

  after_action :verify_authorized
  after_action :verify_policy_scoped



  def new
    authorize @place
    authorize Style
    if policy_scope(Place).include?(@place)
      @style = Style.new
    end
  end

  def create
    authorize @place
    authorize Style

    if policy_scope(Place).include?(@place)
      @style.place = @place

      if @style.save
        redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.style.class'))
      else
        render :action => :new
      end
    end
  end

  def edit
    if policy_scope(Place).include?(@place)||policy_scope(Style).include?(@style)
      authorize @place
      authorize @style
    end
  end

  def update
    authorize @place
    authorize @style

    if policy_scope(Place).include?(@place)||policy_scope(Style).include?(@style)
      if @style.update(style_params)
        redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.style.class'))
      else
        render :action => :edit
      end
    end
  end

  def destroy
    authorize @place
    authorize @style

    if policy_scope(Place).include?(@place)||policy_scope(Style).include?(@style)
      @style.destroy
      redirect_to settings_place_path(@place)
    end
  end

  private

    def set_place
      @place = Place.find_by(slug: params[:user_id])
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
