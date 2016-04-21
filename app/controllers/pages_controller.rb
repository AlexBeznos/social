class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :throw_to_proper_home, if: "params[:id] == 'home'"

  skip_after_action :verify_authorized

  private
  def throw_to_proper_home
    domain = request.host.match(/\..*$/).to_s.gsub(/\./, '')

    if ['am', 'ru', 'us'].include?(domain)
       params[:id] = "home_#{domain}"
    end
  end
end
