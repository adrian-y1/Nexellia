class Post < ApplicationRecord
  validates :body, length: { maximum: 255 }

  belongs_to :user

  has_many :post_likes, foreign_key: "liked_post_id", dependent: :destroy
  has_many :likers, through: :post_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy
end
