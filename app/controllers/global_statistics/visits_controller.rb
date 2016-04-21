class GlobalStatistics::VisitsController < ApplicationController
  def index
    authorize :global_statistics, :visits_index?

    @visits = policy_scope(AhoyVisit)
    @places = policy_scope(Place).includes(:ahoy_visits)
  end
end
