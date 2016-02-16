class PlaceGroupsController < ApplicationController
  before_action :set_place_group, except:[:new, :create]

  after_action :verify_authorized


  def new
    authorize PlaceGroup

    @place_group = PlaceGroup.new
    @subordinated_users = find_subordinated_users
  end

  def create
    authorize PlaceGroup , :new?
    @place_group = PlaceGroup.new(permitted_attributes(PlaceGroup))
    if @place_group.save
      redirect_to places_path, :notice => I18n.t('notice.create', subject: I18n.t('models.place_groups.class'))
    else
      render :action => :new
    end
  end

  def edit
    authorize @place_group

    @subordinated_users = find_subordinated_users
    @message = @place_group.messages.new
    @networks = SocialNetwork.all
    @messages = policy_scope(@place_group.messages)
  end

  def update
    authorize @place_group

    if @place_group.update(permitted_attributes(@place_group))
      redirect_to places_path, :notice => I18n.t('notice.updated', subject: I18n.t('models.place_groups.class'))
    else
      render :action => :edit
    end
  end

  def create_group_message
    authorize @message , :create?

    @message = @place_group.messages.new(permitted_attributes(Message))
    if @message.save
      redirect_to edit_place_group_path, :notice => I18n.t('notice.create', subject: I18n.t('models.message.class'))
    else
      render :action => :edit
    end
  end

  def destroy
    authorize @place_group

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

    def set_place_group
      @place_group = PlaceGroup.find(params[:id])
    end

end
