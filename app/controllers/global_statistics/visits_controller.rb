class GlobalStatistics::VisitsController < ApplicationController
  skip_after_action :verify_authorized

  def index
    @visits = AhoyVisit.all
    @places = Place.all.includes(:ahoy_visits)
  end
end
