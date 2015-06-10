class PlacesController < ApplicationController
  before_filter :require_user
  before_action :find_place, except: :index
  before_filter :require_proper_user, except: :index

  def index
    @places = current_user.get_all_places
  end

  def show
    date = params[:date] ? Date.strptime( params[:date],'%d-%m-%Y' ) : Time.now
    @visits = @place.visits.joins([:customer, :network_profile => :social_network])
    @visits_by_date = @visits.by_date(date.beginning_of_day)
    @visits_this_week = @place.visits.joins(:customer).by_date(1.week.ago)
    @visits_this_month = @place.visits.joins(:customer).by_date(1.month.ago)
  end

  def guests
    @customers = Customer::NetworkProfile.joins(:visits)
                                         .where('customer_visits.place_id = ?', @place.id)
                                         .uniq
                                         .sort_by { |np| np.visits.where(place: @place).count }
                                         .reverse
  end

  def birthdays
    @customers = Customer.joins(:visits)
                         .where('customer_visits.place_id = ?', 1)
                         .where.not(birthday: nil)
                         .uniq
                         .order(:birthday)
  end

  def settings
    @message = params[:message] ? @place.messages.find_by(social_network: SocialNetwork.find_by(name: params[:message])) : @place.messages.first
    @networks = @place.messages.map {|message| message.social_network }.uniq
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      render :action => :new
    end
  end

  private
    def find_place
      @place = Place.find_by_slug(params[:id])
    end


    def place_params
      params.require(:place).permit(:name,
                                    :logo,
                                    :slug,
                                    :enter_by_password,
                                    :password,
                                    :active)
    end

end
