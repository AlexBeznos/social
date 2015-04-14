class Adm::PlacesController < AdministrationController
  before_action :find_user
  before_action :find_place, except: [:new, :create]

  def show
  end

  def new
    @place = Place.new
  end

  def create
    @place = @user.places.new(place_params)

    if @place.save
      redirect_to adm_user_place_path(@user, @place), :notice => 'Place created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@place.errors}"
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to adm_user_place_path(@user, @place), :notice => 'Place updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def destroy
    @place.destroy
    redirect_to adm_user_path(@user), :notice => 'Place destroied!'
  end

  private
  def find_user
    @user = User.find(params[:user_id])
  end

  def find_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:name, :changable_slug)
  end
end
