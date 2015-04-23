class GowifiController < ActionController::Base
  before_action :find_place
  def show
    if @place
      @networks = @place.get_networks
    else
      redirect_to '/404.html'
    end
  end

  def authorize
    session[:state] = Digest::MD5.hexdigest(rand.to_s)
    network = SocialNetworksServices.new(network: params[:network], state: session[:state], slug: params[:slug])
    redirect_to network.get_auth_path
  end

  def no_place
  end

  def omniauth
    if session[:state] != params[:state]
      return render :action => :no_place, :alert => 'Some one tryied to brake you!'
    end
    network = SocialNetworksServices.new(credentials: credentials, slug: params[:place])
    redirect_to network.post_message_and_get_url
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:slug])
  end

  def credentials
    request.env['omniauth.auth']
  end
end
