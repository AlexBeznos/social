class MessagesController < ApplicationController
  before_filter :require_user
  before_action :find_place
  before_action :find_message, except: [:new, :create]
  before_filter :require_proper_user

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.place_id = @place.id

    if @message.save
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :edit
    end
  end

  def destroy
    @message.destroy
    redirect_to settings_place_path(@place)
  end

  private
    def find_place
      @place = Place.find_by_slug(params[:place_id])
    end

    def find_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end

end
