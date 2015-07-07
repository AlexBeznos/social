class Adm::MessagesController < AdministrationController
  before_action :find_place, only: [:new, :create]
  before_action :find_message, except: [:new, :create]


  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.place_id = @place.id

    if @message.save
      redirect_to adm_place_path(@place), :notice => 'Message created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def edit
  end

  def activate
    @message.update(active: true)
    redirect_to adm_place_path(@message.place)
  end

  def deactivate
    @message.update(active: false)
    redirect_to adm_place_path(@message.place)
  end

  def update
    if @message.update(message_params)
      redirect_to adm_place_path(@message.place), :notice => 'Message updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def destroy
    @message.destroy
    redirect_to adm_place_path(@message.place), :notice => 'Place destroied!'
  end

  private
  def find_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def find_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:social_network_id, :message, :message_link, :image, :active, :subscription)
  end
end
