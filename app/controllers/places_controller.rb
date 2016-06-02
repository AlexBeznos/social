class PlacesController < ApplicationController
  before_action :set_place, except: [:new, :create , :index ]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize Place

    @places = policy_scope(sorted_places)
  end

  def new
    authorize Place

    @place = Place.new
  end

  def create
    authorize Place

    @place = Place.new(permitted_attributes(Place))

    if @place.save
      redirect_to user_path(@place.user), notice: I18n.t('notice.create', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      params[:user] = @place.user_id
      render :action => :new
    end
  end

  def show
    authorize @place

    date = params[:date] ? Date.strptime( params[:date],'%d-%m-%Y' ) : Time.zone.now

    @visits_by_date = @place.visits.by_date(date)
    @visits_this_week = @place.visits.by_date_from_to(date - 1.week, date)
    @visits_this_month = @place.visits.by_date_from_to(date - 1.month, date)

    @number_of_friends_by_day = get_number_of_friends @visits_by_date
    @number_of_friends_by_week = get_number_of_friends @visits_this_week
    @number_of_friends_by_month = get_number_of_friends @visits_this_month

  end

  def guests
    authorize @place

    @customers = TopCustomerDecorator.new(@place).call
  end

  def birthdays
    authorize @place

    date_from = params[:date] ? params[:date].to_date : Time.now
    @customers = @place.visits.by_birthday(date_from, date_from + 1.month).uniq
  end

  def settings
    authorize @place
  end

  def edit
    authorize @place

    if current_user.franchisee?
      @subordinated_users = User.where(user_id: current_user.id) + [current_user]
    elsif current_user.admin?
      @subordinated_users = User.all
    end
  end

  def update
    authorize @place

    if @place.update(permitted_attributes(@place))
      redirect_to settings_place_path(@place), notice: I18n.t('notice.updated', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @place

    @place.destroy
    redirect_to request.referer
  end

  private

  #NOTE: to improve this needs statistics#loyalty merging
  def sorted_places
    p params 
    return Place.order(created_at: :desc) if params[:by_created_at]
    Place.order(:name)

  end

  def set_place
    @place = Place.find_by_slug(params[:id])
  end

  def get_number_of_friends(records)
    number = records.map { |visit| visit.try(:account) }
                    .uniq
                    .map { |np| np.try(:friends_count) }
                    .inject{ |sum,x| sum.to_i + x.to_i }

    number ? number : 0
  end
end
