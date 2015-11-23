class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :throw_am_home, if: "params[:id] == 'home'"

  private
  def throw_am_home
    params[:id] = 'home_am' if request.host == 'gofriends.am'
  end
end
