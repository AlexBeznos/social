class PlacesController < ApplicationController
  load_and_authorize_resource :find_by => :slug, except: :new

  def index
    @places = current_user.get_all_places
  end

  def new
    @place = Place.new
    authorize! :create, Place
  end

  def create
    if @place.save
      redirect_to user_path(@place.user), :notice => I18n.t('notice.create', subject: I18n.t('models.places.actions.show.title', place_name: @place.name))
    else
      params[:user] = @place.user_id
      render :action => :new
    end
  end

  def show
    date = params[:date] ? Date.strptime( params[:date],'%d-%m-%Y' ) : Time.zone.now
    @visits_by_date_without_join = @place.visits.by_date(date)
    @visits_by_date = @place.visits.joins([:customer, :network_profile => :social_network]).by_date(date)
    @visits_this_week = @place.visits.joins(:customer).by_date_from_to(date - 1.week, date)
    @visits_this_month = @place.visits.joins(:customer).by_date_from_to(date - 1.month, date)

    @number_of_friends_by_day = get_number_of_friends @visits_by_date_without_join
    @number_of_friends_by_week = get_number_of_friends @visits_this_week
    @number_of_friends_by_month = get_number_of_friends @visits_this_month
  end

  def guests
    @customers = Customer::NetworkProfile.joins(:visits)
                                         .where('customer_visits.place_id = ?', @place.id)
                                         .uniq
                                         .sort_by { |np| np.visits.where(place: @place).count }
                                         .reverse
  end

  def birthdays
    # @customers = Customer.joins(:visits)
    #                      .where('customer_visits.place_id = ?', @place.id)
    #                      .where.not(birthday: nil)
    #                      .uniq
    #                      .order(:birthday)
    if params[:date] 
      day_from = params[:date].to_date.strftime('%d')
      month_from = params[:date].to_date.strftime('%m')
      day_to = (params[:date].to_date + 1.month).strftime('%d')
      month_to = (params[:date].to_date + 1.month).strftime('%m')
    else 
      day_from = Time.zone.now.strftime("%d")
      month_from = Time.zone.now.strftime("%m")
      day_to = 1.month.from_now.strftime("%d")
      month_to = 1.month.from_now.strftime("%m")
    end
    @customers = Customer.joins(:visits)
                         .where('customer_visits.place_id = ?', @place.id)
                         .where("(extract(month from birthday) = ? and extract(day from birthday) >= ?) or 
                                 (extract(month from birthday) = ? and extract(day from birthday) <= ?)", 
                                 month_from, day_from, month_to, day_to)
                         .uniq
                         .sort do |a, b|
                            case 
                              when a.birthday.strftime('%m%d').to_i < b.birthday.strftime('%m%d').to_i 
                                if a.birthday.strftime('%m').to_i == 1 and b.birthday.strftime('%m').to_i == 12
                                  1
                                else
                                  -1
                                end
                              when a.birthday.strftime('%m%d').to_i > b.birthday.strftime('%m%d').to_i 
                                if a.birthday.strftime('%m').to_i == 12 and b.birthday.strftime('%m').to_i == 1
                                  -1
                                else
                                  1
                                end
                              else
                                0
                              end
                            end

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

    def place_params
      params.require(:place).permit(:name,
                                    :logo,
                                    :slug,
                                    :enter_by_password,
                                    :password,
                                    :active,
                                    :redirect_url,
                                    :user_id,
                                    :stocks_active,
                                    :reputation_on,
                                    :simple_enter,
                                    :score_amount,
                                    :loyalty_program)
    end

    def get_number_of_friends(records)
      number = records.map { |visit| visit.network_profile }
                      .uniq
                      .map { |np| np.try(:friends_count) }
                      .inject{ |sum,x| sum.to_i + x.to_i }

      number ? number : 0
    end
end
