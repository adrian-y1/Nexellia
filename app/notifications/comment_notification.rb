class CommentNotification < Noticed::Base
  deliver_by :database
  
  def comment
    params[:message]
  end
  
  def actor
    comment.user
  end

  def message
    comment.parent.nil? ? "commented on your post" : "replied to your comment"
  end

  def url
    post_path(comment.commentable, notification_id: self.record.id)
  end
end
