class FriendshipNotification < Noticed::Base
  deliver_by :database

  def friendship
    params[:message]
  end

  def actor
    friendship.friend
  end

  def message
    "You and #{actor.username} are now friends"
  end

  def url
    user_path(actor)
  end
end
