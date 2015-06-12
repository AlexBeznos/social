class PlacesController < ApplicationController
  before_filter :require_user
  before_action :find_place, except: [:index, :new, :create]
  before_filter :require_proper_user, except: [:index, :new, :create]

  def index
    @places = current_user.get_all_places
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to user_path(@place.user), :notice => I18n.t('notice.create', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      render :action => :new
    end
  end

  def show
    date = params[:date] ? Date.strptime( params[:date],'%d-%m-%Y' ) : Time.now
    @visits_by_date_without_join = @place.visits.by_date(date.beginning_of_day)
    @visits_by_date = @place.visits.joins([:customer, :network_profile => :social_network]).by_date(date.beginning_of_day)
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
    @message = params[:message] ? @place.messages.where(active: true).find_by(social_network: SocialNetwork.find_by(name: params[:message])) : @place.messages.where(active: true).first
    @networks = @place.messages.where(active: true).map {|message| message.social_network }.uniq
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      render :action => :edit
    end
  end

  def destroy
    @place.destroy
    redirect_to request.referer
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
                                    :active,
                                    :user_id)
    end

end
