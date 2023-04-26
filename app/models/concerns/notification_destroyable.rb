module NotificationDestroyable
  extend ActiveSupport::Concern
  include NotificationRecipient
  include NotificationClass

  included do
    before_destroy :destroy_notifications
  end

  def destroy_notifications
    notifications = Notification.where(recipient_id: notification_recipient, type: notification_class.to_s, params: { message: self } )
    notifications.destroy_all
  end
end