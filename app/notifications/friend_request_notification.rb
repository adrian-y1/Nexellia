# To deliver this notification:
#
# FriendRequestNotification.with(post: @post).deliver_later(current_user)
# FriendRequestNotification.with(post: @post).deliver(current_user)

class FriendRequestNotification < Noticed::Base
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

  def friend_request
    params[:message]
  end

  def receiver
    friend_request.receiver
  end

  def sender_profile
    friend_request.sender.profile
  end
  
  def sender
    friend_request.sender
  end

  def url
    user_path(sender)
  end
end
