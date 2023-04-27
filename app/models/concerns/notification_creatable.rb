module NotificationCreatable
  extend ActiveSupport::Concern
  include NotificationClass
  include NotificationRecipient

  included do
    after_create_commit :create_notification
  end

  def create_notification
    return if actor == notification_recipient
    notification_class.with(message: self).deliver_later(notification_recipient)
  end

  private 

  def actor
    case self.class.name
    when "Comment"
      self.user
    when "Like"
      self.user
    end
  end
end