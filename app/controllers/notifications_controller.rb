class NotificationsController < ApplicationController

  def index
    authorize Notification

    @notifications = Notifications.where(user: current_user)
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
