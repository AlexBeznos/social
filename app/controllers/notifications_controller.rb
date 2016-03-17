class NotificationsController < ApplicationController
  before_action :set_notification, only: :destroy

  def index
    authorize Notification

    @sources = policy_scope(Notification).where(category: "Unapproved authentication").map(&:source)

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
