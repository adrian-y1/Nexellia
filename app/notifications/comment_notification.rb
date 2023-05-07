class CommentNotification < Noticed::Base
  deliver_by :database
  
  def comment
    params[:message]
  end
  
  def actor
    comment.user
  end

  def message
    comment.parent.nil? ? "#{actor.full_name} commented on your post" : "#{actor.full_name} replied to your comment"
  end

  def url
    post_path(comment.commentable, notification_id: self.record.id)
  end
end
