class Adm::PlacesController < AdministrationController
  load_and_authorize_resource :user
  load_and_authorize_resource :find_by => :slug, :through => :user, :shallow => true

  def show
    @place = Place.includes(:messages).find_by_slug(params[:id])
    @networks = SocialNetwork.all
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.user_id = @user.id

    if @place.save
      redirect_to adm_place_path(@user), :notice => 'Place created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@place.errors}"
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to adm_place_path(@place), :notice => 'Place updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@place.errors}"
    end
  end

  def destroy
    @place.destroy
    redirect_to adm_user_path(@place.user), :notice => 'Place destroied!'
  end

  private

  def place_params
    params.require(:place).permit(:name,
                                  :logo,
                                  :slug,
                                  :enter_by_password,
                                  :password,
                                  :active,
                                  :redirect_url,
                                  :template,
                                  :background_active,
                                  :mobile_image,
                                  :tablet_image,
                                  :desktop_image)
  end
end
