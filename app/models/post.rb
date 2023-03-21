# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  body             :text
#  comments_count   :integer          default(0)
#  post_likes_count :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 255, message: "Post description length exceeded." }

  belongs_to :user, counter_cache: true

  has_many :post_likes, foreign_key: "liked_post_id", dependent: :destroy
  has_many :likers, through: :post_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  has_many :comments

  scope :user_and_friends_posts, -> (user) { includes(:user).where(user_id: [user.id] + user.friends.pluck(:id)).order(id: :desc) }


  after_create_commit -> do 
    broadcast_prepend_later_to [self.user.id, "posts"], partial: "posts/post", locals: { post: self, user: Current.user }, target: "posts" 
  end

  after_update_commit -> do 
    broadcast_update_later_to [self.user.id, "posts"], locals: { post: self, user: Current.user } 
    broadcast_update_later_to self, partial: "posts/show_page_post", locals: { post: self, user: Current.user } , target: self
  end
  
  after_destroy_commit -> do 
    broadcast_remove_to [self.user.id, "posts"] 
    broadcast_remove_to self
  end
end
