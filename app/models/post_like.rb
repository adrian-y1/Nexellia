class PostLike < ApplicationRecord
  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_post, class_name: "Post", foreign_key: "liked_post_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_post_id, message: "has already liked this post" }
end
