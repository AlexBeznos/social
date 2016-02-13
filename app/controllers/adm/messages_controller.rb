class Adm::MessagesController < AdministrationController
before_action :set_place
before_action :set_message, except:[:new, :create]

after_action :verify_authorized


  def new
    authorize Message

    @message = Message.new
  end

  def create
    authorize Message

    @message = Message.new(permitted_attributes(Message))
    @message.with_message = @place

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
      redirect_to adm_place_path(message_path), :notice => 'Message updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@message.errors}"
    end
  end

  def activate
    authorize @message, :update?

    @message.update(active: true)
    redirect_to adm_place_path(message_path)
  end

  def deactivate
    authorize @message, :update?

    @message.update(active: false)
    redirect_to adm_place_path(message_path)
  end

  def destroy
    authorize @message

    @message.destroy
    redirect_to adm_place_path(message_path), :notice => 'Place destroyed!'
  end

  private

    def set_place
      @place = Place.find_by(slug:params[:place_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end

    def message_path
      if @message.with_message_type == "Place"
        Place.find_by(id: @message.with_message_id)
      elsif @message.with_message_type == "PlaceGroup"
        Place.find_by(place_group_id: @message.with_message_id)
      end
    end
end
