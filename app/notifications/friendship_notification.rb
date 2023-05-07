class FriendshipNotification < Noticed::Base
  deliver_by :database

  def friendship
    params[:message]
  end

  def actor
    friendship.friend
  end

  def message
    "You and #{actor.full_name} are now friends"
  end

  def url
    user_path(actor, notification_id: self.record.id)
  end
end
