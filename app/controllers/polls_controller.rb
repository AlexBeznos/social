class PollsController < ApplicationController
  before_action :set_poll, except: [:index, :new, :create ]
  before_action :set_place

  def index
    authorize Poll

    @polls = @place.polls
  end

  def show
    authorize @poll
  end

  def new
    authorize Poll

    @poll = @place.polls.new
    @poll.answers.build
  end

  def edit
    authorize @poll

    @poll.answers.build
  end

  def creatу
    authorize Poll

    @poll = @place.polls.new(permitted_attributes(Poll))

    if @poll.save
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.create', subject: I18n.t('models.polls.class'))
    else
      render :action => :new
    end
  end

  def update
    authorize @p

    if @poll.update(permitted_attributes(Poll))
      redirect_to place_poll_path(id: @poll.id, place_id: @place.slug), :notice => I18n.t('notice.updated', subject: I18n.t('models.polls.class'))
    else
      render :action => :edit
    end
  end

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
    @place = Place.find_by_slug(params[:place_id])
  end
end
