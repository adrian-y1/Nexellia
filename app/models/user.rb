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
  include ActionView::RecordIdentifier

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

  scope :not_friends_with, -> (user) { where.not(id: [user.id] + user.friends.pluck(:id)) }

  def create_friendship(friend)
    self.friends << friend
    friend.friends << self
  end

  def self.authentication_keys
    [:username]
  end

  # Checks if user has liked the given post or not
  def liked?(post)
    liked_posts.include?(post)
  end

  # If the user has liked the given post:
  # => Unlike the post by destroying it from the user's liked_posts
  # Else => Like the post by inserting it into the user's liked_posts
  #
  # Create a public target that can be seen by every user listening.
  # It broadcasts a replace to the stream of `[post_obj]:likes` and makes it's target the 
  # given public target (`post_[post.id]_likes`).
  # Then it renders the post_like partial that includes the post_likes_count
  def like(post)
    if liked_posts.include?(post)
      liked_posts.destroy(post)
    else
      liked_posts << post
    end
    public_target = "#{dom_id(post)}_likes"
    broadcast_replace_later_to [post, 'likes'], target: public_target, partial: 'post_likes/post_like', locals: { post: post }
  end

  # Checks if the given user is already a friend of the current user.
  def is_friends_with?(user)
    self.friends.include?(user)
  end

  # Checks if the current user has already sent a friend request to the given user.
  def has_sent_friend_request_to?(user)
    receiver_ids = self.friend_requests_sent.pluck(:receiver_id)
    receiver_ids.include?(user.id)
  end

  # Checks if the current user has already received a friend request from the given user.
  def has_received_friend_request_from?(user)
    sender_ids = self.friend_requests_received.pluck(:sender_id)
    sender_ids.include?(user.id)
  end

  # Checks if the current user can send a friend request to the given user.
  def can_send_friend_request?(user)
    [is_friends_with?(user), has_sent_friend_request_to?(user), has_received_friend_request_from?(user)].all?
  end
end
