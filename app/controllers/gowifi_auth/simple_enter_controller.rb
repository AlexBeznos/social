class GowifiAuth::SimpleEnterController < GowifiAuthController
  before_action :find_place, only: :create

  def create
    @auth = @place.auths.active.find_by({ resource_type: SimpleAuth, step: Auth.steps[session[:auth_step]] })

    redirect_to @auth ? succed_auth_path(@place, @auth) : gowifi_place_path(@place)
  end
end
