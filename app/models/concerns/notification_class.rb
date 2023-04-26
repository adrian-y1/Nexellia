module NotificationClass
  extend ActiveSupport::Concern

  def notification_class
    case self.class.name
    when "Comment"
      CommentNotification
    when "CommentLike" 
      CommentLikeNotification
    when "PostLike"
      PostLikeNotification
    when "Friendship"
      FriendshipNotification
    when "FriendRequest"
      FriendRequestNotification
    end
  end
end