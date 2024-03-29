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
    @views_by_date = @place.by_date_for_place(date.to_time)
    @views_by_week = @place.by_date_from_to_for_place(date - 1.week, date)
    @views_by_month = @place.by_date_from_to_for_place(date - 1.month, date)
    @number_of_views_by_day = @views_by_date.map(&:access_count_day).join.to_i
    @number_of_views_by_week = @views_by_week.map(&:access_count_week).join.to_i
    @number_of_views_by_month = @views_by_month.map(&:access_count_month).join.to_i

    if date.between?(DateTime.now, date + 7.day) || date.between?(date - 7.day, DateTime.now - 1.day) || @place.updated_at.to_time.between?(date.to_time.beginning_of_day, date.to_time.end_of_day)
      @number_of_views_by_day
    else
      @place.up_to_day
    end

    if @place.updated_at.to_time.between?(date.to_time.beginning_of_day - 1.week, date.to_time.end_of_day + 1.week)
      @number_of_views_by_week
    else
      @place.up_to_week
    end

    if @place.updated_at.to_time.between?(date.to_time.beginning_of_day - 1.month, date.to_time.end_of_day + 1.month)
      @number_of_views_by_month
    else
      @place.up_to_month
    end

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

  def sorted_places
    return Place.order(created_at: :desc) if params[:by_created_at].try(:to_bool)
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
