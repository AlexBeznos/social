class AnswersController < ApplicationController
  def new
  end

  def create
    @answer = Answer.new(answer_params)
    respond_to do |format|
  		format.html { redirect_to @poll }
  		format.js
	end
  end

  def index
  	@answers = Answer.find_by(:poll_id)
  end

  private

    def answer_params
      params.require(:answer).permit(:content, :poll_id)
    end
end
