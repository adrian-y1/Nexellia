# == Schema Information
#
# Table name: comment_likes
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  liked_comment_id :integer
#  liker_id         :integer
#
class CommentLike < ApplicationRecord
  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_comment, class_name: "Comment", foreign_key: "liked_comment_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_comment_id, message: "has already liked this comment" }

  after_create_commit :create_notification
  before_destroy :destroy_notifications

  private

  def create_notification
    return if liker == liked_comment.user

    CommentLikeNotification.with(message: self).deliver_later(liked_comment.user)
  end

  # Destroys all notifications associated with this like
  def destroy_notifications
    notifications = Notification.where(recipient_id: self.liked_comment.user, type: "CommentLikeNotification", params: { message: self })
    notifications.destroy_all
  end
end
