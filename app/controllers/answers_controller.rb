class AnswersController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :poll, :through => :place
  load_and_authorize_resource :through => :poll

  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.where(poll_id: @poll.id)
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @answer = Answer.where(poll_id: @poll.id).first
  end

  # GET /answers/new
  def new
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.where(poll_id: @poll.id).first
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    @answer.poll_id = @poll.id
    if @answer.save
      redirect_to place_poll_answers_path(@place, @poll), :notice => I18n.t('notice.create', subject: I18n.t('models.answers.class'))
    else
      render :action => :new
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    if @answer.update(answer_params)
      redirect_to place_poll_answers_path(@place, @poll), :notice => I18n.t('notice.update', subject: I18n.t('models.answers.class'))
    else
      render :action => :edit 
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to place_poll_answers_path(@place, @poll), notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content)
    end
end
