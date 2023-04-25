# To deliver this notification:
#
# FriendshipNotification.with(post: @post).deliver_later(current_user)
# FriendshipNotification.with(post: @post).deliver(current_user)

class FriendshipNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #

  def friendship
    params[:message]
  end

  def friend
    friendship.friend
  end

  def user
    friendship.user
  end
  
  def friend_profile
    friend.profile
  end

  def url
    user_path(friend)
  end
end
