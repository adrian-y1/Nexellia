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
  include NotificationCreatable
  include NotificationDestroyable

  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_comment, class_name: "Comment", foreign_key: "liked_comment_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_comment_id, message: "has already liked this comment" }

  has_noticed_notifications
end
