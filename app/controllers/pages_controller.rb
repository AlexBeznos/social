class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :throw_home_am, if: "params[:id] == 'home'"

  private
  def throw_home_am
    params[:id] = 'home_am' if request.host.match /gofriends\.am/
  end
end
