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
    network = SocialNetworksServices.new(network: params[:network], state: Digest::MD5.hexdigest(rand.to_s))
    redirect_to network.get_auth_path
  end

  def no_place
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:slug])
  end
end
