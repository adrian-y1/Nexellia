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
    sender_stream = [self.sender.id, self.receiver.id]
    receiver_stream = [self.receiver.id, self.sender.id]
    partial = "users/friend_request_form"
    sender_stream_locals = { logged_in_user: self.sender, user: self.receiver, friend_request: self }
    receiver_stream_locals = { logged_in_user: self.receiver, user: self.sender, friend_request: self }
    sender_frame, receiver_frame = dom_id(self.sender), dom_id(self.receiver)

    if destroyed?
      # Synchronous broadcasting for the after_destroy_commit to fix Deserialization Error
      broadcast_replace_to sender_stream, target: receiver_frame, partial: partial, locals: sender_stream_locals
      broadcast_replace_to receiver_stream, target: sender_frame, partial: partial, locals: receiver_stream_locals
    else
      # Asynchronous broadcasting for the after_create_commit
      broadcast_replace_later_to sender_stream, target: receiver_frame, partial: partial, locals: sender_stream_locals
      broadcast_replace_later_to receiver_stream, target: sender_frame, partial: partial, locals: receiver_stream_locals
    end
  end

  def prevent_duplicate_friend_requests
    if FriendRequest.exists?(sender: sender, receiver: receiver)
      errors.add(:sender, "you have already sent a friend request to #{sender.username}.")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender)
      errors.add(:sender, "you have already received a friend request from #{receiver.username}.")
    end
  end
end
