class MessagesController < ApplicationController

  before_action :set_place
  before_action :set_message, except:[:new, :create ]

  after_action :verify_authorized

  def new
    authorize Message
    @place = Place.find_by(slug:params[:place_id])
    @message = Message.new
  end

  def create
    authorize Message
    @message = Message.new(permitted_attributes(Message))
    @message.with_message = @place

    if @message.save
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :new
    end
  end

  def edit


      authorize @message

  end

  def update
    authorize @message

    if @message.update(permitted_attributes(Message))
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @message

    @message.destroy
    redirect_to settings_place_path(@place)
  end

  private

    def set_place
      @place = Place.find_by(slug:params[:place_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
