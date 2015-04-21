class Adm::MessagesController < AdministrationController
  before_action :find_user
  before_action :find_place
  before_action :find_message, except: [:new, :create]


  def new
    @message = Message.new
  end

  def create
    @message = @place.messages.new(message_params)

    if @message.save
      redirect_to adm_user_place_path(@user, @place), :notice => 'Message created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def edit
  end

  def activate
    @message.update(active: true)
    redirect_to adm_user_place_path(@user, @place)
  end

  def deactivate
    @message.update(active: false)
    redirect_to adm_user_place_path(@user, @place)
  end

  def update
    if @message.update(message_params)
      redirect_to adm_user_place_path(@user, @place), :notice => 'Message updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def destroy
    @message.destroy
    redirect_to adm_user_place_path(@user, @place), :notice => 'Place destroied!'
  end

  private
  def find_user
    @user = User.find(params[:user_id])
  end

  def find_place
    @place = Place.find_by_slug(params[:place_id])
  end

  def find_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:network, :message, :redirect_link, :message_link, :image, :active)
  end
end
