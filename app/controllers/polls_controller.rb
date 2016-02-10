class PollsController < ApplicationController
  # load_and_authorize_resource :place, find_by: :slug
  # load_and_authorize_resource :poll, through: :place


  before_action :set_poll , except: [:index , :new , :create ]
  before_action :set_place
  after_action :verify_authorized
  after_action :verify_policy_scoped

  # GET /polls
  def index
    if policy_scope(Place).include?(@place)
      authorize Poll
      authorize @place , :show?
      @polls = @place.polls
    end
  end

  # GET /polls/1
  def show
    if policy_scope(Place).include?(@place)||policy_scope(Poll).include?(@poll)
      authorize @poll
      authorize @place
    end
  end

  # GET /polls/new
  def new
    if policy_scope(Place).include?(@place)
      authorize Poll
      authorize @place , :show?
      @poll = @place.polls.new
      @poll.answers.build
    end
  end

  # GET /polls/1/edit
  def edit
    if policy_scope(Place).include?(@place)||policy_scope(Poll).include?(@poll)
      authorize @poll
      authorize @place
      @poll.answers.build
    end
  end

  # POST /polls
  def create
    if policy_scope(Place).include?(@place)
      authorize Poll
      authorize @place , :update?
      @poll = @place.polls.new(permitted_attributes(Poll))

      if @poll.save
        redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.create', subject: I18n.t('models.polls.class'))
      else
        render :action => :new
      end
    end
  end

  # PATCH/PUT /polls/1
  def update
    if policy_scope(Place).include?(@place)||policy_scope(Poll).include?(@poll)
      authorize @poll
      authorize @place , :update?
      if @poll.update(permitted_attributes(Poll))
        redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.updated', subject: I18n.t('models.polls.class'))
      else
        render :action => :edit
      end
    end
  end

  # DELETE /polls/1
  def destroy
    if policy_scope(Place).include?(@place)||policy_scope(Poll).include?(@poll)
      authorize @poll
      authorize @place , :update?
      @poll.destroy

      respond_to do |format|
        format.html { redirect_to place_polls_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.polls.class')) }
      end
    end
  end

  private

  def set_poll
    @poll = Poll.find(params[:id])
  end

  def set_place
    @place = Place.find_by(slug:params[:place_id])
  end


end
