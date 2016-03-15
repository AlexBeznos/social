class NotificationsController < ApplicationController
  before_action :set_notification, only: :destroy

  def index
    authorize Notification

    if current_user.franchisee?
      @sources = current_user.notifications.where(category: "Unapproved authentication").map(&:source)
    else
      @sources = Notification.all
    end
  end

  def destroy
    authorize @notification

    @notification.destroy
    redirect_to user_notifications_path(current_user)
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
