class MessagesController < ApplicationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :through => :place

  def new
  end

  def create
    @message.with_message_id = @place.id

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

    def message_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end

end
