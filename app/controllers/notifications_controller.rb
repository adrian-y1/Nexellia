class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).newest_first.includes(:recipient)
  end

  def update
    notification = Notification.find(params[:id])
    notification.update(is_closed: true)
  end

  def destroy_all
    current_user.notifications.destroy_all
    redirect_to request.referrer
  end
end
