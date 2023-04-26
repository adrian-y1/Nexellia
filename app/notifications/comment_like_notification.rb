class CommentLikeNotification < Noticed::Base
  deliver_by :database
  
  def comment_like
    params[:message]
  end

  def actor
    comment_like.liker
  end

  def message
    "#{actor.username} liked your comment"
  end

  def url
    post_path(comment_like.liked_comment.post)
  end
end
