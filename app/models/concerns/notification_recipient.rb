module NotificationRecipient
  extend ActiveSupport::Concern
  
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