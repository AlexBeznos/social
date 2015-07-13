class Adm::StylesController < AdministrationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :style, :through => :place, :shallow => true, :singleton => true

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
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@style.errors}"
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

  def style_params
    params.require(:style).permit(:background,
                                  :js,
                                  :css,
                                  :text_color,
                                  :greating_color)
  end
end
