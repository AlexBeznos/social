class PlaceGroupsController < ApplicationController
  load_and_authorize_resource :place_group

  def new
    @subordinated_users = find_subordinated_users
    @place_group = PlaceGroup.new
  end

  def create
    if @place_group.save
      redirect_to places_path, :notice => I18n.t('notice.create', subject: I18n.t('models.place_groups.class'))
    else
      render :action => :new
    end
  end

  def edit
    @subordinated_users = find_subordinated_users
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
    def find_subordinated_users
      if current_user.franchisee? 
        User.where(user_id: current_user.id, group: 0)
      elsif current_user.admin?
        if @place_group.user
          User.where(user_id: @place_group.user.user_id, group: 0) 
        else
          User.where(group: 0)
        end 
      end
    end

    def place_group_params
      params.require(:place_group).permit(:name, :user_id)
    end

    def msg_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end
end