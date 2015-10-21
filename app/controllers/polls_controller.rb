class PollsController < ApplicationController
  load_and_authorize_resource :place, find_by: :slug
  load_and_authorize_resource :poll, through: :place
  
  # GET /polls
  def index
    @polls = @place.polls
  end

  # GET /polls/1
  def show
  end

  # GET /polls/new
  def new
    @poll = @place.polls.new
    @poll.answers.build
  end

  # GET /polls/1/edit
  def edit
    @poll.answers.build
  end

  # POST /polls
  def create
    @poll = @place.polls.new(poll_params)

    if @poll.save
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.create', subject: I18n.t('models.polls.class'))
    else
      render :action => :new
    end
  end

  # PATCH/PUT /polls/1
  def update
    if @poll.update(poll_params)
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.updated', subject: I18n.t('models.polls.class'))
    else
      render :action => :edit 
    end
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to place_polls_path(@place), :notice => I18n.t('notice.deleted', subject: I18n.t('models.polls.class')) }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:question, answers_attributes: [:id, :content, :_destroy])
    end
end
