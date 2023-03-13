# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comment_likes_count    :integer          default(0)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  post_likes_count       :integer          default(0)
#  posts_count            :integer          default(0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15, message: "must be between 3-15 characters," }

  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy

  has_and_belongs_to_many :friends, class_name: "User", join_table: "friendships", foreign_key: "user_id", 
                          association_foreign_key: "friend_id", dependent: :destroy

  has_many :posts
  
  has_many :post_likes, foreign_key: "liker_id", dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :liked_post, foreign_key: "liked_post_id", dependent: :destroy

  has_many :comments

  has_many :comment_likes, foreign_key: "liker_id", dependent: :destroy
  has_many :liked_comments, through: :comment_likes, source: :liked_comment, foreign_key: "liked_comment_id", dependent: :destroy

  def create_friendship(friend)
    self.friends << friend
    friend.friends << self
  end

  def self.authentication_keys
    [:username]
  end
end
