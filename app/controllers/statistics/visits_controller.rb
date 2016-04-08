class Statistics::VisitsController < ApplicationController
  def index
    authorize :statistics, :visits_index?

    @place = Place.find_by_slug(params[:place_id])
    @visits = @place.ahoy_visits
  end
end

