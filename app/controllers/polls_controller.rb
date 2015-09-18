class PollsController < ApplicationController

  def new
  end

  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      flash[:success] = 'Poll was created, now add answers for it!'
      redirect_to @poll
    else
      render 'new'
    end
  end

  def index
  	@polls = current_user.polls
  end

  def edit
  end

  def update
  end

  private

    def poll_params
      params.require(:poll).permit(:question, :answers_number, :user_id)
    end
end
