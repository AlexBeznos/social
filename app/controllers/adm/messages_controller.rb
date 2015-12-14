class Adm::MessagesController < AdministrationController
  load_and_authorize_resource :place, :find_by => :slug
  load_and_authorize_resource :message, :through => :place, :shallow => true


  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.with_message = @place

    if @message.save
      redirect_to adm_place_path(@place), :notice => 'Message created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to adm_place_path(message_path), :notice => 'Message updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def activate
    @message.update(active: true)
    redirect_to adm_place_path(message_path)
  end

  def deactivate
    @message.update(active: false)
    redirect_to adm_place_path(message_path)
  end

  def destroy
    @message.destroy
    redirect_to adm_place_path(message_path), :notice => 'Place destroyed!'
  end

  private

    def message_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :active, :subscription)
    end

    def message_path
      if @message.with_message_type == "Place"
        Place.find_by(id: @message.with_message_id) 
      elsif @message.with_message_type == "PlaceGroup"
        Place.find_by(place_group_id: @message.with_message_id)
      end
    end
end
