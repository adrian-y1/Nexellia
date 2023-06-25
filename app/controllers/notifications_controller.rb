class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).newest_first.includes(:recipient)
  end
end
