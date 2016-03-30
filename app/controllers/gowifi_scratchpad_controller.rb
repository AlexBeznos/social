class GowifiScratchpadController < ApplicationController
  layout "gowifi_scratchpad"

  skip_after_action :verify_authorized

  def show
    @place = Place.find_by_slug(params[:slug])
    @auth = Auth.find(params[:auth])
    @menu_item = @place.menu_items
                   .order("RANDOM()")
                   .first
  end

end
