class PlaceGroupsController < ApplicationController
  load_and_authorize_resource :place_group
  
  def new
    @place_group = PlaceGroup.new
  end

  def create
    @place_group.user_id = current_user.id
    if @place_group.save
      redirect_to places_path, :notice => I18n.t('notice.create', subject: I18n.t('models.place_groups.class'))
    else
      render :action => :new
    end
  end

  def edit
    @message = @place_group.messages.new
    @networks = SocialNetwork.all
    @messages = @place_group.messages
  end

  def update

    if @place_group.update(place_group_params)
      redirect_to places_path, :notice => I18n.t('notice.updated', subject: I18n.t('models.place_groups.class'))
    else
      render :action => :edit
    end
  end

  def create_group_message
    @message = @place_group.messages.new(msg_params)
    
    if @message.save
      redirect_to edit_place_group_path, :notice => I18n.t('notice.create', subject: I18n.t('models.message.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    @place_group.destroy
    redirect_to places_path, :notice => I18n.t('notice.deleted', subject: I18n.t('models.place_groups.class'))
  end

  private
    def place_group_params
      params.require(:place_group).permit(:name)
    end

    def msg_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end
end