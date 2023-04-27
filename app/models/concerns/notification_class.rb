module NotificationClass
  extend ActiveSupport::Concern

  def notification_class
    case self.class.name
    when "Comment"
      CommentNotification
    when "Friendship"
      FriendshipNotification
    when "FriendRequest"
      FriendRequestNotification
    when "Like"
      LikeNotification
    end
  end
end