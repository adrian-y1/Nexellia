class CommentNotification < Noticed::Base
  deliver_by :database
  
  def comment
    params[:message]
  end
  
  def actor
    comment.user
  end

  def message
    "#{actor.username} commented on your post"
  end

  def url
    post_path(comment.commentable, notification_id: self.record.id)
  end
end
