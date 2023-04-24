# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class CommentNotification < Noticed::Base
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
  def comment
    params[:message]
  end
  
  def creator
    comment.user
  end

  def creator_profile
    comment.user.profile
  end

  def post
    comment.post
  end

  def post_author
    comment.post.user
  end

  def url
    post_path(comment.post)
  end
end
