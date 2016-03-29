class GowifiScratchpadController < ApplicationController
  skip_after_action :verify_authorized

  def show
    @place = Place.find(params[:place])
    @url = params[:url]
    @item_image = MenuItem.where(place_id: params[:id])
                    .order("RANDOM()")
                    .first
                    .image
  end
end
