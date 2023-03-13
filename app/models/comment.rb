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
  belongs_to :user
  belongs_to :post, counter_cache: true

  has_many :comment_likes, foreign_key: "liked_comment_id", dependent: :destroy
  has_many :likers, through: :comment_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  validates :body, presence: true, length: { maximum: 255, message: "Comment length exceeded." }
end
