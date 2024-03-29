class AuthsController < ApplicationController
  before_action :set_place
  before_action :set_auth, except: [:new, :create]

  def new
    authorize Auth
    @auth = Auth.new
  end

  def create
    authorize Auth

    @auth = Auth.new(auth_params(:method))
    @auth.place = @place

    if @auth.save
      notify(current_user, @auth)

      redirect_to settings_place_path(@place)
    else
      render action: :new
    end
  end

  def edit
    authorize @auth
  end

  def update
    authorize @auth

    if @auth.update(auth_params(:resource_attributes))
      notify(current_user, @auth)

      redirect_to settings_place_path(@place)
    else
      render action: :edit
    end
  end

  def destroy
    authorize @auth

    if @auth.network?
      @auth.update(active: false)
    else
      @auth.destroy
    end

    redirect_to settings_place_path(@place)
  end

  private

  def notify(user, auth)
    user.general? ? auth.modify! : auth.approve!
  end

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def set_auth
    @auth = Auth.find(params[:id])
  end

  def auth_params(method)
    r = params[:auth].delete(method)
    params.require(:auth).permit(:redirect_url, :resource_type, :step).tap do |p|
      p[:resource_attributes] = r
    end
  end
end
