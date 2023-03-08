class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 255, message: "Post description length exceeded." }

  belongs_to :user, counter_cache: true

  has_many :post_likes, foreign_key: "liked_post_id", dependent: :destroy
  has_many :likers, through: :post_likes, source: :liker, foreign_key: "liker_id", dependent: :destroy

  has_many :comments

  scope :user_and_friends_posts, -> (user) { includes(:user).where(user_id: [user.id] + user.friends.pluck(:id)).order(id: :desc) }

  after_create_commit -> { broadcast_prepend_later_to "posts", partial: "posts/post", locals: { post: self, user: Current.user }, target: "posts" }
  after_update_commit -> { broadcast_update_later_to "posts", locals: { post: self, user: Current.user } }
  after_destroy_commit -> { broadcast_remove_to "posts" }
end
