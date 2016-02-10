class PlaceGroupMessagesController < ApplicationController

  before_action :set_message, except: [:new , :create]
  before_action :set_place_group

  after_action :verify_authorized
  after_action :verify_policy_scoped , except: [:new ]

  def new
    authorize @place_group
    authorize Message
    @message = @place_group.messages.new
  end

  def create
    authorize @place_group , :update?
    authorize Message
    @message = @place_group.messages.new (permitted_attributes(Message))

    if policy_scope(PlaceGroup).include?(@place_group)
      if @message.save
        p @place_group
        redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
      else
        render :action => :new
      end
    end
  end

  def update
    authorize @place_group , :update?
    authorize @message
    if policy_scope(Message).include?(@message) && policy_scope(PlaceGroup).include?(@place_group)
      if @message.update(permitted_attributes(Message))
        redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
      else
        render :action => :edit
      end
    end
  end

  def edit
    if policy_scope(Message).include?(@message) && policy_scope(PlaceGroup).include?(@place_group)
      authorize @place_group
      authorize @message
    end
  end

  def destroy
    authorize @place_group
    authorize @message

    if policy_scope(Message).include?(@message) && policy_scope(PlaceGroup).include?(@place_group)
      @message.destroy
      redirect_to edit_place_group_path(@place_group), :notice => I18n.t('notice.deleted', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    end
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

    def set_place_group
      @place_group = PlaceGroup.find(params[:place_group_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
