# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  access_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  posts_count            :integer          default(0)
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :string           default("offline"), not null
#  uid                    :string
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
  after_update_commit { broadcast_replace_to_online_friends }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: %i[facebook]
  
  validates :first_name, presence: true, length: { minimum: 2, maximum: 30, message: "must be between 2-30 characters" }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 30, message: "must be between 2-30 characters"  }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }

  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :friendships, foreign_key: "user_id", dependent: :destroy
  has_many :friends, through: :friendships, source: :friend, foreign_key: "friend_id", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy

  scope :excluding_user, -> (user) { where.not(id: [user.id]) }
  scope :load_profiles, -> { includes(profile: { picture_attachment: :blob }) }
  scope :excluding_friends_and_requests, -> (user) {
    where.not(
      id: [user.id] + user.friends.pluck(:id) + user.friend_requests_sent.pluck(:receiver_id) + user.friend_requests_received.pluck(:sender_id)
    )
  }
  
  def destroy_profile
    profile.destroy
  end

  def online?
    status == "online"
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  # Checks if user has liked the given likeable (post or comment) or not
  def liked?(likeable)
    likes.where(likeable: likeable).exists?
  end

  # If the user has liked the given likeable (post or comment):
  #   => Unlike the likeable by destroying it from the user's likes
  # Else 
  #   => Like the likeable by inserting it into the user's likes
  # brooadcast the likes to the likeable's stream
  def like(likeable)
    like = likes.find_by(likeable: likeable)
    if like
      like.destroy
    else
      likes.create(likeable: likeable)
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

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split(" ")[0] # assuming the user model has a first_name
      user.last_name = auth.info.name.split(" ")[1] # assuming the user model has a last_name
      user.access_token = auth.credentials.token
    end
  end

  private

  def broadcast_replace_to_online_friends
    broadcast_replace_to "online_friends", target: "friend_#{self.id}_card", partial: "users/user", locals: { user: self }
  end

  # Create a public target (`likeable_id_likes`) that can be seen by every user listening.
  # It broadcasts a replace to the stream of `likeable_id:likes` depending on if the likeable
  # is a Post or a Comment which updates the likes count for the likeable in real-time.
  # If the likeable is a post, broadcast to both #index and #show pages.
  def broadcast_likes_to_likeable(likeable)
    public_target = "#{dom_id(likeable)}_likes"
    stream_name = [likeable, 'likes']
    if likeable.is_a?(Post)
      broadcast_replace_later_to stream_name, target: "#{public_target}_show", partial: 'likes/post_likes_count', locals: { post: likeable, page: :show }
      broadcast_replace_later_to stream_name, target: "#{public_target}_index", partial: 'likes/post_likes_count', locals: { post: likeable, page: :index }
    else
      broadcast_replace_later_to stream_name, target: public_target, partial: 'likes/comment_likes_count', locals: { comment: likeable }
    end
  end
end
