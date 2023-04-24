# == Schema Information
#
# Table name: comments
#
#  id                  :bigint           not null, primary key
#  body                :text
#  comment_likes_count :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  post_id             :integer
#  user_id             :integer
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  
  belongs_to :user
  belongs_to :post, counter_cache: true

  has_noticed_notifications model_name: 'Notification'

  has_many :comment_likes, foreign_key: "liked_comment_id", dependent: :destroy
  has_many :likers, through: :comment_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  validates :body, presence: true, length: { maximum: 255, message: "Comment length exceeded." }

  # Eager load the user, profile, :picture_attachment and :blob to solve N + 1 queries problem
  scope :with_user_and_profile_includes, -> { includes(user: { profile: { picture_attachment: :blob } }) }

  after_create_commit -> do
    broadcast_append_later_to [post, "comments"], target: "#{dom_id(post)}_comments", partial: "comments/comment", locals: { comment: self, user: Current.user }
    broadcast_replace_later_to [post, "comments"], target: "#{dom_id(post)}_comments_count", partial: "comments/comment_count", locals: { post: post }
    broadcast_notifications
  end
  
  before_destroy :destroy_notifications

  after_destroy_commit -> do
    broadcast_remove_to [post, "comments"]
    broadcast_replace_to [post, "comments"], target: "#{dom_id(post)}_comments_count", partial: "comments/comment_count", locals: { post: post }
  end

  private

  def broadcast_notifications
    return if user == post.user

    CommentNotification.with(message: self).deliver_later(post.user)

    broadcast_to_unread_notifications
    broadcast_to_all_notifications
  end

  # Broadcasts the new notification to the user's unread_notifications which is displayed under the navbar
  def broadcast_to_unread_notifications
    broadcast_prepend_later_to "unread_notifications_#{post.user.id}", target: "unread_notifications_#{post.user.id}",
      partial: "notifications/unread_notification", locals: {user:, post:, unread: true }
  end

  # Broadcasts a prepend to the user's all_notifications drop menu list
  def broadcast_to_all_notifications
    broadcast_prepend_later_to "all_notifications_#{post.user.id}", target: "all_notifications_#{post.user.id}",
      partial: "notifications/all_notifications_item",
      locals: { created_at: Time.current, post: self.post, user: self.user, comment: self, profile: self.user.profile }
  end

  # Destroys all notifications associated with this comment
  def destroy_notifications
    notifications = Notification.where(recipient_id: self.post.user, type: "CommentNotification", params: { message: self })
    notifications.destroy_all
  end
end
