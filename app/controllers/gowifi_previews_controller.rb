class GowifiPreviewsController < ApplicationController
  layout 'gowifi_previews'

  skip_after_action :verify_authorized

  def show
    @auth = Auth.find(params[:auth_id])
    @provider_name = @auth.name.to_s
    @place = Place.find_by_slug(params[:slug])
  end
end
