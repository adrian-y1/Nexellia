module NotificationDestroyable
  extend ActiveSupport::Concern

  included do
    before_destroy :destroy_notifications
  end

  def destroy_notifications
    notifications = Notification.where(recipient_id: notification_recipient, type: "#{self.class.name}Notification", params: { message: self } )
    notifications.destroy_all
  end

  private

  def notification_recipient
    case self.class.name
    when "Comment"
      self.post.user
    when "CommentLike" 
      self.liked_comment.user
    when "PostLike"
      self.liked_post.user
    when "Friendship"
      self.user
    when "FriendRequest"
      self.receiver
    end
  end
end