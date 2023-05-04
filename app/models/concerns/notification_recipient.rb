module NotificationRecipient
  extend ActiveSupport::Concern
  
  def notification_recipient
    case self.class.name
    when "Comment"
      if self.parent.nil?
        self.commentable.user
      else
        self.parent.user
      end
    when "Friendship"
      self.user
    when "FriendRequest"
      self.receiver
    when "Like"
      self.likeable.user
    end
  end
end