# == Schema Information
#
# Table name: friendships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :integer
#  user_id    :integer
#
# Indexes
#
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id) UNIQUE
#
class Friendship < ApplicationRecord
  include ActionView::RecordIdentifier
  include NotificationCreatable
  include NotificationDestroyable

  validates :user, uniqueness: { scope: :friend_id, message: "already friends" }

  belongs_to :user
  belongs_to :friend, class_name: "User"

  has_noticed_notifications

  after_create :create_inverse_friendship
  after_destroy :destroy_inverse_friendship
  after_destroy_commit :broadcast_friend_destruction

  # Broadcast the approperiate form for both the friend request sender and receiver once they become friends
  def broadcast_friend_creation(friend_request)
    broadcast_data = streams_and_locals(friend_request.sender, friend_request.receiver, friend_request)
    broadcast_friendship_update(broadcast_data)
  end

  private 

  # Broadcast the approperiate form for both the user removing their friend, and the friend getting removed
  def broadcast_friend_destruction
    broadcast_data = streams_and_locals(user, friend, FriendRequest.new)
    broadcast_friendship_update(broadcast_data)
  end

  # Broadcasts the updates for both the sender & receiver of the friend request or
  # the user & the friend, based on the given broadcast data
  def broadcast_friendship_update(broadcast_data)
    broadcast_replace_to broadcast_data[:sender_stream], target: broadcast_data[:receiver_frame], partial: "users/friend_request_form", 
      locals: broadcast_data[:sender_locals]
    broadcast_replace_to broadcast_data[:receiver_stream], target: broadcast_data[:sender_frame], partial: "users/friend_request_form", 
      locals: broadcast_data[:receiver_locals]
  end

  # Returns a hash containing the data required for broadcast friend creation and destruction
  def streams_and_locals(sender, receiver, friend_request)
    {
      sender_stream: [sender.id, receiver.id],
      receiver_stream: [receiver.id, sender.id],
      sender_frame: dom_id(sender),
      receiver_frame: dom_id(receiver),
      sender_locals: { logged_in_user: sender, user: receiver, friend_request: friend_request },
      receiver_locals: { logged_in_user: receiver, user: sender, friend_request: friend_request }
    }
  end

  def create_inverse_friendship
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_friendship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end
end
