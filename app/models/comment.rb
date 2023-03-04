class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :comment_likes, foreign_key: "liked_comment_id", dependent: :destroy
  has_many :likers, through: :comment_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  validates :body, presence: true, length: { maximum: 255, message: "Comment length exceeded." }
end
