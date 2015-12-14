class Adm::PlacesController < AdministrationController
  load_and_authorize_resource :user
  load_and_authorize_resource :find_by => :slug, :through => :user, :shallow => true

  def index
    @places = Place.all.order('id ASC')
  end

  def show
    @place = Place.includes(:messages).find_by_slug(params[:id])
    @networks = SocialNetwork.all
    @messages = all_messages
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.user_id = @user.id

    if @place.save
      redirect_to adm_place_path(@place), :notice => 'Place created!'
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
    redirect_to adm_user_path(@place.user), :notice => 'Place destroyed!'
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
                                  :desktop_image,
                                  :simple_enter,
                                  :loyalty_program,
                                  :sms_auth)
  end

  def all_messages
    Message.where("with_message_id = ? and with_message_type = 'Place' or with_message_id = ? and with_message_type = 'PlaceGroup'", @place.id, @place.place_group_id)
  end
end
