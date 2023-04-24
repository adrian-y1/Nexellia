# To deliver this notification:
#
# PostLikeNotification.with(post: @post).deliver_later(current_user)
# PostLikeNotification.with(post: @post).deliver(current_user)

class PostLikeNotification < Noticed::Base
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
  
  def post_like
    params[:message]
  end

  def liker
    post_like.liker
  end

  def liker_profile
    post_like.liker.profile
  end

  def liked_post
    post_like.liked_post
  end

  def liked_post_author
    post_like.liked_post.user
  end

  def url
    post_path(post_like.liked_post)
  end
end
