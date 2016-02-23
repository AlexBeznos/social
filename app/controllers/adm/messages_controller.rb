class Adm::MessagesController < AdministrationController
before_action :set_place
before_action :set_message, except: [:new, :create]

  def new
    authorize Message

    @message = Message.new
  end

  def create
    authorize Message

    @message = Message.new(permitted_attributes(Message))
    @message.place = @place

    if @message.save
      redirect_to adm_place_path(@place), :notice => 'Message created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def edit
    authorize @message
  end

  def update
    authorize @message

    if @message.update(permitted_attributes(Message))
      redirect_to adm_place_path(@message.place), :notice => 'Message updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def activate
    authorize @message, :update?

    @message.update(active: true)
    redirect_to adm_place_path(@message.place)
  end

  def deactivate
    authorize @message, :update?

    @message.update(active: false)
    redirect_to adm_place_path(@message.place)
  end

  def destroy
    authorize @message

    @message.destroy
    redirect_to adm_place_path(@message.place), :notice => 'Place destroyed!'
  end

  private
  def set_place
    @place = Place.find_by(slug:params[:place_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
