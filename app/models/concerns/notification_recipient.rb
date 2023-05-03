module NotificationRecipient
  extend ActiveSupport::Concern
  
  def notification_recipient
    case self.class.name
    when "Comment"
      self.commentable.user
    when "Friendship"
      self.user
    when "FriendRequest"
      self.receiver
    when "Like"
      self.likeable.user
    end
  end
end