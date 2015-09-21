class PollsController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :poll, :through => :place
  
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.where(place_id: @place.id)
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    @poll = Poll.where(place_id: @place.id).first
  end

  # GET /polls/new
  def new
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.where(place_id: @place.id).first
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)
    @poll.place_id = @place.id
    if @poll.save
      redirect_to place_polls_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.polls.class'))
    else
      render :action => :new
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    if @poll.update(poll_params)
      redirect_to place_polls_path(@place), :notice => I18n.t('notice.update', subject: I18n.t('models.polls.class'))
    else
      render :action => :edit 
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to place_polls_path(@place), :notice => I18n.t('notice.delete', subject: I18n.t('models.polls.class')) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:question)
    end
end
