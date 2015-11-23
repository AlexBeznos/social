class CategoriesController < ApplicationController
  load_and_authorize_resource :category
  
  def new
    @category = Category.new
  end

  def create
    @category.user_id = current_user.id
    if @category.save
      redirect_to places_path, :notice => I18n.t('notice.create', subject: I18n.t('models.categories.class'))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to places_path, :notice => I18n.t('notice.updated', subject: I18n.t('models.categories.class'))
    else
      render :action => :edit
    end
  end

  def set_group_message
    all_saved = []
    
    Place.where(category_id: @category.id).each do |place|
      @message = Message.new(msg_params)
      @message.place_id = place.id
      if @message.save
        all_saved << true
      else
        all_saved << false
      end
    end

    if all_saved.all? && !all_saved.empty?
      redirect_to places_path, :notice => I18n.t('notice.create', subject: I18n.t('models.messages.message_for', name: @message.social_network.name))
    else
      render :action => :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to places_path, :notice => I18n.t('notice.deleted', subject: I18n.t('models.categories.class'))
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def msg_params
      params.require(:message).permit(:social_network_id, :message, :message_link, :image, :subscription)
    end
end