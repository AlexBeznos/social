class GowifiController < ApplicationController
  include Consumerable

  layout false
  before_action :find_place, only: [:show, :enter_by_poll, :submit_poll]
  before_action :set_place_slug, only: :show
  before_action :find_customer, only: :show
  before_filter :check_for_place_activation, only: :show

  def show
    @networks = @place.get_networks
    @stock = @place.get_proper_stock
  end

  def enter_by_poll
    @poll = @place.polls.sample
  end

  def submit_poll
    @answer = Answer.find(params[:poll][:answer_ids].to_i)
    if @answer.increment!(:number_of_selections)
      redirect_to wifi_login_path
    else
      render :action => :enter_by_poll 
    end
  end

  private

    def find_place
      @place = Place.find_by_slug(params[:slug])
    end

    # we add slug to session to make sure
    # place slug  will be saved in omniauth or at least session
    def set_place_slug
      session[:slug] = @place.slug
    end

    def find_customer
      @customer = Customer.find(cookies[:customer].to_i) if cookies[:customer]
    end

    def check_for_place_activation
      return redirect_to '/404.html' unless @place
      redirect_to wifi_login_path unless @place.try(:active)
    end
end
