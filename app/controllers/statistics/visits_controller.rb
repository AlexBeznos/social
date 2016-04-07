class Statistics::VisitsController < ApplicationController
  skip_after_action :verify_authorized
  before_action :set_place

  def index
    @visits = @place.ahoy_visits
  end

  private

  def set_place
    @place = Place.find_by_slug(params[:place_id])
  end
end

