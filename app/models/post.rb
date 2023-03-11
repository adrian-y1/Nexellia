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
  end
  
  after_destroy_commit -> { broadcast_remove_to [self.user.id, "posts"] }
end
