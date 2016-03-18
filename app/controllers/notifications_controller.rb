class NotificationsController < ApplicationController

  def index
    authorize Notification

    @sources = policy_scope(Notification).where(category: "Unapproved authentication").map(&:source)

  end

  def destroy
    authorize Notification

    Notification.find(params[:id]).destroy
    redirect_to user_notifications_path(current_user)
  end
end
