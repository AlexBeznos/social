class GowifiAuth::OmniauthController < GowifiAuthController
  before_action :find_place, only: :create
  before_action :find_auth, only: :create
  before_action :check_facebook_permissions, only: :create
  after_action :ahoy_authenticate, only: :create

  def create
    decorator = NetworksAuthDecorator.new(
      credentials: credentials,
      auth: @auth,
      place: @place,
      customer_id: get_customer_cookie
    )

    decorator.save
    session.delete(:slug)
    set_customer_cookie(decorator.customer.id)

    redirect_to succed_auth_path(@place, @auth)
  end

  def failure
    redirect_to 'http://ya.ru'
  end

  private

  def credentials
    request.env['omniauth.auth']
  end

  def find_place
    slug_by_omni = request.env.try(:[], 'omniauth.params').try(:[], 'place')
    slug_by_session = session[:slug]

    @place = Place.find_by_slug(slug_by_omni || slug_by_session)
  end

  def find_auth
    @auth = @place.auths
                  .active
                  .resource_like(credentials['provider'].capitalize)
                  .find_by(step: Auth.steps[session[:auth_step]])
  end

  def check_facebook_permissions
    if credentials['provider'] == 'facebook'
      if !FacebookService.publishing_permitted?(credentials['credentials']['token'])
        redirect_to gowifi_place_path(@place), alert: 'Error'
      end
    end
  end

end
