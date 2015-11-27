class PlaceGroupMessagesController < ApplicationController
  load_and_authorize_resource :place_group
  load_and_authorize_resource :message, :through => :place_group
  before_action :set_message, only: [:edit, :destroy, :activate, :deactivate, :update]

  def new
    @message = @place_group.messages.new
  end

  def create
    @message = @place_group.messages.new(message_params)
    
    if @message.save
      redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :new
    end
  end

  def update
    if @message.update(message_params)
      redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :edit
    end
  end

  def edit
  end

  def destroy
    @message.destroy
    redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.deleted', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
  end

  def activate
    @message.update(active: true)
    redirect_to edit_place_group_path(id: @message.with_message_id)
  end

  def deactivate
    @message.update(active: false)
    redirect_to edit_place_group_path(id: @message.with_message_id)
  end

  private

    def message_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
