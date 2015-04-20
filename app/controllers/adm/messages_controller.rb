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
    @place = Place.find(params[:place_id])
  end

  def find_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:type, :message, :redirect_link, :message_link)
  end
end