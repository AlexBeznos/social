class GowifiScratchpadController < ApplicationController
  layout "gowifi_scratchpad"

  skip_after_action :verify_authorized

  def show
    @place = Place.find_by_slug(params[:id])
    @auth = params[:auth]
    @menu_item = MenuItem.where(place_id: params[:id])
                   .order("RANDOM()")
                   .first
  end
end
