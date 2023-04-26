class PostLikeNotification < Noticed::Base
  deliver_by :database

  def post_like
    params[:message]
  end

  def actor
    post_like.liker
  end

  def message
    "#{actor.username} liked your post"
  end

  def url
    post_path(post_like.liked_post)
  end
end
