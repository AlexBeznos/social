class GowifiAuth::OmniauthController < GowifiAuthController
  before_action :find_place, only: :create
  before_action :find_auth, only: :create
  before_action :check_facebook_permissions, only: :create
  skip_after_action :set_auth_step, only: :failure

  def create
    decorator = NetworksAuthDecorator.new(
      credentials: credentials,
      auth: @auth,
      place: @place,
    )

    decorator.customer_id = current_customer_session.customer.try(:id)
    decorator.save
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
    slug_by_session = current_customer_session.place.slug

    @place = Place.find_by_slug(slug_by_omni || slug_by_session)
  end

  def find_auth
    p "*" * 60
    p current_customer_session.auth_step
    @auth = @place.auths
                  .active
                  .resource_like(credentials['provider'].capitalize)
                  .find_by(step: current_customer_session.auth_step)
  end

  def check_facebook_permissions
    if credentials['provider'] == 'facebook'
      if !FacebookService.publishing_permitted?(credentials['credentials']['token'])
        redirect_to gowifi_place_path(@place), alert: 'Error'
      end
    end
  end

end
