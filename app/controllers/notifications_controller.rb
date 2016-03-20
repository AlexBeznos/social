class NotificationsController < ApplicationController

  def index
    authorize Notification

    @sources = policy_scope(Notification).where(category: :unapproved_authentication).map(&:source)

  end

  def approve
  end

  def unapprove
  end

  def destroy
    authorize Notification

    Notification.find(params[:id]).destroy
    redirect_to user_notifications_path(current_user)
  end
end
