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
  include NotificationCreatable
  include NotificationDestroyable
  
  belongs_to :liker, class_name: "User", foreign_key: "liker_id", counter_cache: true
  belongs_to :liked_post, class_name: "Post", foreign_key: "liked_post_id", counter_cache: true

  validates :liker, uniqueness: { scope: :liked_post_id, message: "has already liked this post" }

  has_noticed_notifications
end
