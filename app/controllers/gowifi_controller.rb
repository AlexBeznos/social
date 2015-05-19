class GowifiController < ActionController::Base
  layout 'no-layout'
  before_action :find_place, only: :show

  def show
    if @place
      @networks = @place.get_networks
    else
      redirect_to '/404.html'
    end
  end

  def authorize
    session[:state] = Digest::MD5.hexdigest(rand.to_s)
    session[:slug] = params[:slug]

    network = SocialNetworksServices.new(network: params[:network], state: session[:state], slug: session[:slug])
    redirect_to network.get_auth_path
  end

  def no_place
  end

  def omniauth
    if session[:state] != params[:state] && params[:provider] != 'instagram'
      return render :action => :no_place, :alert => 'Some one tryied to brake you!'
    end

    network = SocialNetworksServices.new( credentials: credentials,
                                          slug: session[:slug] )

    redirect_to network.post_message_and_get_url
  end

  def set_locale
    if I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      I18n.locale = params[:locale]
    end

    redirect_to request.referrer
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def credentials
    request.env['omniauth.auth']
  end
end
