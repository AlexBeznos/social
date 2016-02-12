class PollsController < ApplicationController
  before_action :set_poll , except: [:index , :new , :create ]
  before_action :set_place
  after_action :verify_authorized

  # GET /polls
  def index
    authorize Poll
    @polls = @place.polls
  end

  # GET /polls/1
  def show
    authorize @poll
  end

  # GET /polls/new
  def new
    authorize Poll
    @poll = @place.polls.new
    @poll.answers.build
  end

  # GET /polls/1/edit
  def edit
    authorize @poll
    @poll.answers.build
  end

  # POST /polls
  def creatу
    authorize Poll
    @poll = @place.polls.new(permitted_attributes(Poll))

    if @poll.save
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.create', subject: I18n.t('models.polls.class'))
    else
      render :action => :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    authorize @poll
    if @poll.update(permitted_attributes(Poll))
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.updated', subject: I18n.t('models.polls.class'))
    else
      render :action => :edit
    end
  end

  # DELETE /polls/1
  def destroy
    authorize @poll
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to place_polls_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.polls.class')) }
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
