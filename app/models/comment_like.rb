class CommentLike < ApplicationRecord
  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_comment, class_name: "Comment", foreign_key: "liked_comment_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_comment_id, message: "has already liked this comment" }
end
