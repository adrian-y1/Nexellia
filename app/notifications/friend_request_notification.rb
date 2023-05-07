class FriendRequestNotification < Noticed::Base
  deliver_by :database

  def friend_request
    params[:message]
  end
  
  def actor
    friend_request.sender
  end

  def message
    "#{actor.full_name} sent you a friend request"
  end

  def url
    user_path(actor, notification_id: self.record.id)
  end
end
