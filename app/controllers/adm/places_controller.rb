class Adm::PlacesController < AdministrationController
  before_action :set_place, except: [:index, :new, :create]
  before_action :set_user, only: [:new, :create]

  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize Place
    @places = Place.all.order('id ASC')
  end

  def show
    authorize @place

    @place = Place.includes(:messages).find_by_slug(params[:id])
    @networks = SocialNetwork.all
    @messages = all_messages
  end

  def new
    authorize Place
    @place = Place.new
  end

  def create
    authorize Place
    @place = Place.new(permitted_attributes(Place))
    @place.user_id = @user.id

    if @place.save
      redirect_to adm_place_path(@place), :notice => 'Place created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@place.errors}"
    end
  end

  def edit
    authorize @place
  end

  def update
    authorize @place
    if @place.update(permitted_attributes(Place))
      redirect_to adm_place_path(@place), :notice => 'Place updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@place.errors}"
    end
  end

  def destroy
    authorize @place
    @place.destroy
    redirect_to adm_user_path(@place.user), :notice => 'Place destroyed!'
  end

  private

  def set_place
    @place = Place.find_by(slug: params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def all_messages
    Message.where("with_message_id = ? and with_message_type = 'Place' or with_message_id = ? and with_message_type = 'PlaceGroup'", @place.id, @place.place_group_id)
  end
end
