class Adm::StylesController < AdministrationController
  before_action :set_place
  before_action :set_style, except: [:new, :create]

  def new
    authorize Style

    @style = Style.new
  end

  def create
    authorize Style

    @style = Style.new(permitted_attributes(Style))
    @style.place_id = @place.id

    if @style.save
      redirect_to adm_place_path(@place), :notice => 'Style created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@style.errors}"
    end
  end

  def edit
    authorize @style
  end

  def update
    authorize @style

    if @style.update(permitted_attributes(Style))
      redirect_to adm_place_path(@style.place), :notice => 'Styles updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@style.errors}"
    end
  end

  def remove_background
    authorize @style, :update?

    @style.background.destroy
    @style.background.clear
    @style.save
    redirect_to adm_place_path(@style.place), :notice => 'Background deleted!'
  end

  def destroy
    authorize Style

    @style.destroy
    redirect_to adm_place_path(@style.place), :notice => 'Styles destroyed!'
  end

  private

  def set_place
    @place = Place.find_by(slug:params[:place_id])
  end

  def set_style
    @style = Style.find(params[:id])
  end
end
