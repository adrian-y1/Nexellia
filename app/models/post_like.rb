# == Schema Information
#
# Table name: post_likes
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  liked_post_id :integer
#  liker_id      :integer
#
# Indexes
#
#  index_post_likes_on_liker_id_and_liked_post_id  (liker_id,liked_post_id) UNIQUE
#
class PostLike < ApplicationRecord
  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_post, class_name: "Post", foreign_key: "liked_post_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_post_id, message: "has already liked this post" }

  has_noticed_notifications

  after_create_commit :create_notification
  before_destroy :destroy_notifications

  private
  
  def create_notification
    return if liker == liked_post.user
    
    PostLikeNotification.with(message: self).deliver_later(liked_post.user)
  end

  # Destroys all notifications associated with this like
  def destroy_notifications
    notifications = Notification.where(recipient_id: self.liked_post.user, type: "PostLikeNotification", params: { message: self })
    notifications.destroy_all
  end
end
