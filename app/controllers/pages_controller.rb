class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :throw_to_proper_home, if: "params[:id] == 'home'"
  skip_after_action :verify_authorization

  private
  def throw_to_proper_home
    if request.host.match /gofriends\.am/
      params[:id] = 'home_am'
    elsif request.host.match /go-friends\.ru/
      params[:id] = 'home_ru'
    end
  end
 end
