class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15, message: "must be between 3-15 characters," }

  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy

  has_and_belongs_to_many :friends, class_name: "User", join_table: "friendships", foreign_key: "user_id", association_foreign_key: "friend_id", dependent: :destroy

  has_many :posts

  def create_friendship(friend)
    self.friends << friend
    friend.friends << self
  end

  def self.authentication_keys
    [:username]
  end
end
