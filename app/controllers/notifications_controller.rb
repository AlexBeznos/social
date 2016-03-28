class NotificationsController < ApplicationController
  before_action :set_notification, only: [:approve, :unapprove]

  def index
    authorize Notification

    @sources = policy_scope(Notification).map(&:source)
  end

  def approve
    authorize @notification

    @notification.source.approve!
    redirect_to user_notifications_path(current_user)
  end

  def unapprove
    authorize @notification

    @notification.source.unapprove!
    redirect_to user_notifications_path(current_user)
  end

  private
  def set_notification
    @notification = Notification.find(params[:id])
  end

end
