class GowifiAuth::PasswordController < GowifiAuthController
  before_action :find_place, only: :create
  before_action :find_or_create_customer, only: :create

  def create
    @auth = @place.auths.active.find_by({ resource_type: PasswordAuth, step: Auth.steps[session[:auth_step]] })

    if @auth && @auth.resource.password == params[:password]
      profile = Profile.create_with_resource({provider: 'password'}, @customer)
      Customer::Visit.create(
        place: @place,
        account_id: profile.resource_id,
        account_type: profile.resource_type,
        customer: profile.customer
      )

      redirect_to succed_auth_path(@place, @auth)
    else
      redirect_to gowifi_place_path(@place)
    end
  end

  private

  def find_or_create_customer
    if get_customer_cookie
      @customer = Customer.find(get_customer_cookie.to_i)
    else
      @customer = Customer.create
      set_customer_cookie(@customer.id)
    end
  end
end
