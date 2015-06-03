class PlacesController < ApplicationController
  before_filter :require_user
  before_action :find_place, except: :index

  def index
    @places = current_user.get_all_places
  end

  def show
  end

  private
    def find_place
      @place = Place.find_by_slug(params[:id])
    end
end
