class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.unread
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.mark_as_read!
    redirect_to @notification.to_notification.url
  end
end
