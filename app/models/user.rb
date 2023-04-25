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

  after_create :create_profile
  after_destroy :destroy_profile
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15, message: "must be between 3-15 characters," }

  has_many :notifications, as: :recipient, dependent: :destroy

  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy

  has_many :friendships, foreign_key: "user_id", dependent: :destroy
  has_many :friends, through: :friendships, source: :friend, foreign_key: "friend_id", dependent: :destroy

  has_many :posts, dependent: :destroy
  
  has_many :post_likes, foreign_key: "liker_id", dependent: :destroy
  has_many :liked_posts, through: :post_likes, source: :liked_post, foreign_key: "liked_post_id", dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :comment_likes, foreign_key: "liker_id", dependent: :destroy
  has_many :liked_comments, through: :comment_likes, source: :liked_comment, foreign_key: "liked_comment_id", dependent: :destroy

  has_one :profile, dependent: :destroy

  scope :excluding_user, -> (user) { where.not(id: [user.id]) }

  def create_friendship(friend)
    self.friends << friend
    friend.friends << self
  end

  def destroy_friendship(friend)
    self.friends.destroy(friend)
    friend.friends.destroy(self)
  end

  # Checks if user has liked the given likeable (post or comment) or not
  def liked?(likeable)
    items = liked_items(likeable)
    items.include?(likeable)
  end

  # If the user has liked the given likeable (post or comment):
  #   => Unlike the likeable by destroying it from the user's liked_posts/liked_comments
  # Else 
  #   => Like the likeable by inserting it into the user's liked_posts/liked_comments
  # brooadcast the likes to the likeable's stream
  #
  # Also used the safe navigation operator, "&.", which is a shorthand for 
  # checking if an object is not nil before calling a method on it
  def like(likeable)
    items = liked_items(likeable)
    if items&.include?(likeable)
      items.destroy(likeable)
    else
      items&.<< likeable
    end
    broadcast_likes_to_likeable(likeable)
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

  private

  # Create a public target (`likeable_id_likes`) that can be seen by every user listening.
  # It broadcasts a replace to the stream of `likeable_id:likes` depending on if the likeable
  # is a Post or a Comment which updates the likes count for the likeable in real-time.
  def broadcast_likes_to_likeable(likeable)
    public_target = "#{dom_id(likeable)}_likes"
    stream_name = [likeable, 'likes']
    if likeable.is_a?(Post)
      broadcast_replace_later_to stream_name, target: public_target, partial: 'post_likes/post_like', locals: { post: likeable }
    else
      broadcast_replace_later_to stream_name, target: public_target, partial: 'comment_likes/comment_like', locals: { comment: likeable }
    end
  end

  # If the given likeable is a Post, then get all the user's liked_posts
  # else, get his/her liked_comments
  def liked_items(likeable)
    likeable.is_a?(Post) ? liked_posts : liked_comments
  end

  def self.authentication_keys
    [:username]
  end
end
