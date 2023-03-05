class Post < ApplicationRecord
  validates :body, length: { maximum: 255 }

  belongs_to :user, counter_cache: true

  has_many :post_likes, foreign_key: "liked_post_id", dependent: :destroy
  has_many :likers, through: :post_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  has_many :comments

  scope :user_and_friends_posts, ->(user) { includes(:user).where(user_id: [user.id] + user.friends.pluck(:id)).order(created_at: :asc) }
end
