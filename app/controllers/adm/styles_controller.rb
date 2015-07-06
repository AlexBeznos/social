class Adm::StylesController < AdministrationController
  before_action :find_place, only: [:new, :create]
  before_action :find_style, except: [:new, :create]

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)
    @style.place_id = @place.id

    if @style.save
      redirect_to adm_place_path(@place), :notice => 'Style created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@style.errors}"
    end
  end

  def edit
  end

  def update
    if @style.update(style_params)
      redirect_to adm_place_path(@style.place), :notice => 'Styles updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@style.errors}"
    end
  end

  def remove_background
    @style.background.destroy
    @style.background.clear
    @style.save
    redirect_to adm_place_path(@style.place), :notice => 'Background deleted!'
  end

  def destroy
    @style.destroy
    redirect_to adm_place_path(@style.place), :notice => 'Styles destroied!'
  end

  private

  def find_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def find_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:background,
                                  :js,
                                  :css,
                                  :text_color,
                                  :greating_color)
  end
end
