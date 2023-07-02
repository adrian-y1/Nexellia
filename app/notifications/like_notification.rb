class LikeNotification < Noticed::Base
  deliver_by :database

  def like
    params[:message]
  end

  def actor
    like.user
  end

  def message
    likeable_type = like.likeable_type == 'Post' ? "post" : "comment"
    "liked your #{likeable_type}"    
  end

  def url
    post = get_post_from_likeable
    post_path(post, notification_id: self.record.id)
  end

  private 

  def get_post_from_likeable
    if like.likeable_type == 'Post'
      Post.find(like.likeable_id)
    else
      Comment.find(like.likeable_id).commentable
    end
  end
end
