class MessagesController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped , except:[:new, :create ]
  before_action :set_place_params
  before_action :set_message_params ,except:[:new, :create ]

  def new
    authorize Place
    authorize Message

    @place = Place.find_by(slug:params[:place_id])
    @message = Message.new
  end

  def create
    authorize Place
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
    if policy_scope(Message)&&policy_scope(Place)
      authorize @place
      authorize @message
    end
  end

  def update
    authorize @place
    authorize @message
    if policy_scope(Message)&&policy_scope(Place)
      if @message.update(permitted_attributes(Message))
        redirect_to settings_place_path(@place), :notice => I18n.t('notice.updated', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
      else
        render :action => :edit
      end
    end
  end

  def destroy
    authorize @place
    authorize @message
    if policy_scope(Message)&&policy_scope(Place)
      @message.destroy
      redirect_to settings_place_path(@place)
    end
  end

  private

    def set_place_params
      @place = Place.find_by(slug:params[:place_id])
    end

    def set_message_params
      @message = Message.find(params[:id])
    end
end
