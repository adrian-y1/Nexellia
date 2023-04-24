# To deliver this notification:
#
# CommentLikeNotification.with(post: @post).deliver_later(current_user)
# CommentLikeNotification.with(post: @post).deliver(current_user)

class CommentLikeNotification < Noticed::Base
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
  
  def comment_like
    params[:message]
  end

  def liker
    comment_like.liker
  end

  def liker_profile
    comment_like.liker.profile
  end

  def liked_comment
    comment_like.liked_comment
  end

  def liked_comment_author
    comment_like.liked_comment.user
  end

  def url
    post_path(comment_like.liked_comment.post)
  end
end
