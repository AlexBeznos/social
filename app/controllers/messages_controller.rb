class MessagesController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped
  before_action :set_place
  before_action :set_message ,except:[:new, :create ]

  def new
    authorize Place , :show?
    authorize Message

    @place = Place.find_by(slug:params[:place_id])
    if policy_scope(Place).include?(@place)
      @message = Message.new
    end
  end

  def create
    authorize Place , :update?
    authorize Message
    @message = Message.new(permitted_attributes(Message))
    @message.with_message = @place

    if @message.save && policy_scope(Place).include?(@place)
      redirect_to settings_place_path(@place), :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :new
    end
  end

  def edit
    if policy_scope(Message).include?(@message) && policy_scope(Place).include?(@place)
      authorize @place , :update?
      authorize @message
    end
  end

  def update
    authorize @place , :update?
    authorize @message
    if policy_scope(Message).include?(@message) && policy_scope(Place).include?(@place)
      if @message.update(permitted_attributes(Message))
        redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
      else
        render :action => :edit
      end
    end
  end

  def destroy
    authorize @place , :update?
    authorize @message
    if policy_scope(Message)include?(@message) && policy_scope(Place).include?(@place)
      @message.destroy
      redirect_to settings_place_path(@place)
    end
  end

  private

    def set_place
      @place = Place.find_by(slug:params[:place_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
