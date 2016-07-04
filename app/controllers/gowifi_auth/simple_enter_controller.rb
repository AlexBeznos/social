class GowifiAuth::SimpleEnterController < GowifiAuthController
  before_action :find_place, only: :create

  def create
    @auth = @place.auths.active.find_by({ resource_type: SimpleAuth, step: Auth.steps[current_customer_session.auth_step] })
    if @auth
      current_customer_session.next_auth_step
      redirect_to succed_auth_path(@place, @auth)
    else
      gowifi_place_path(@place)
    end
  end
end
