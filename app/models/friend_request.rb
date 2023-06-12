# == Schema Information
#
# Table name: friend_requests
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :integer
#  sender_id   :integer
#
# Indexes
#
#  index_friend_requests_on_sender_id_and_receiver_id  (sender_id,receiver_id) UNIQUE
#
class FriendRequest < ApplicationRecord
  include ActionView::RecordIdentifier
  include NotificationCreatable
  include NotificationDestroyable

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  validate :prevent_duplicate_friend_requests

  has_noticed_notifications model_name: 'Notification'

  scope :load_receiver_and_sender_profiles, -> { includes([receiver: [profile: [picture_attachment: [:blob]]], sender: [profile: [picture_attachment: [:blob]]]]) }

  after_create_commit do 
    broadcast_friend_request
  end

  # This sets up an `after_destroy_commit` callback to broadcast the friend request when it is destroyed,
  # unless the two users are already friends. This prevents the broadcast from being triggered
  # when the `FriendRequest` object is destroyed in the `FriendshipsController` after the two users become friends.
  after_destroy_commit :broadcast_friend_request, unless: :are_friends?
   
  private
  
  def are_friends? 
    receiver.is_friends_with?(sender) || sender.is_friends_with?(receiver)
  end

  def broadcast_friend_request
    broadcast_data = streams_and_locals

    if destroyed?
      broadcast_friend_request_destruction(broadcast_data)
    else
      broadcast_friend_request_creation(broadcast_data)
    end
  end

  # Broadcasts the approperiate friend request form after a friend request is destroyed,
  # based on the conditions in the partial, for both the sender and the receiver
  # Synchronous broadcasting avoid fix Deserialization Error
  def broadcast_friend_request_destruction(broadcast_data)
    broadcast_replace_to broadcast_data[:sender_stream], target: broadcast_data[:receiver_frame], partial: broadcast_data[:partial], 
      locals: broadcast_data[:sender_locals]
    broadcast_replace_to broadcast_data[:receiver_stream], target: broadcast_data[:sender_frame], partial: broadcast_data[:partial],
      locals: broadcast_data[:receiver_locals]
  end

  # Broadcasts the approperiate friend request form after a friend request is created,
  # based on the conditions in the partial, for both the sender and the receiver
  def broadcast_friend_request_creation(broadcast_data)
    broadcast_replace_later_to broadcast_data[:sender_stream], target: broadcast_data[:receiver_frame], partial: broadcast_data[:partial], 
      locals: broadcast_data[:sender_locals]
    broadcast_replace_later_to broadcast_data[:receiver_stream], target: broadcast_data[:sender_frame], partial: broadcast_data[:partial],
      locals: broadcast_data[:receiver_locals]
  end

  # Returns a hash containing the data required for broadcasting friend request
  def streams_and_locals
    {
      sender_stream: [sender.id, receiver.id],
      receiver_stream: [receiver.id, sender.id],
      sender_frame: dom_id(sender),
      receiver_frame: dom_id(receiver),
      sender_locals: { logged_in_user: sender, user: receiver, friend_request: self },
      receiver_locals: { logged_in_user: receiver, user: sender, friend_request: self },
      partial: "users/friend_request_form"
    }
  end

  def prevent_duplicate_friend_requests
    if FriendRequest.exists?(sender: sender, receiver: receiver)
      errors.add(:sender, "you have already sent a friend request to #{sender.full_name}.")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender)
      errors.add(:sender, "you have already received a friend request from #{receiver.full_name}.")
    end
  end
end
