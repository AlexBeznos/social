class NotificationsController < ApplicationController

  def index
    authorize Notification

    @notifications = current_user.notifications
  end

  def destroy
    authorize @notification

    @notification.destroy
    redirect_to notifications_path
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
