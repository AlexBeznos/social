class NotificationsController < ApplicationController

  def index
    authorize Notification

    @sources = policy_scope(Notification).map(&:source)
  end

  def approve
    authorize @notification

    @notification.source.approve!
    if notification.destroy
      redirect_to user_notifications_path(current_user)
    end
  end

  def unapprove
    authorize @notification

    @notification.source.unapprove!
    if @notification.destroy
      redirect_to user_notifications_path(current_user)
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
