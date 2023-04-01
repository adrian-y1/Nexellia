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
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  validate :prevent_duplicate_friend_requests

  after_create_commit :broadcast_friend_request_form_replace

  private

  def broadcast_friend_request_form_replace
    # Sends a replace broadcast to the Sender's stream, targeting the Receiver's turbo frame to perform the form changes.
    broadcast_replace_later_to [self.sender.id, self.receiver.id], target: "user_#{self.receiver.id}", partial: "users/friend_request_form", 
      locals: { logged_in_user: self.sender, user: self.receiver, friend_request: self }

    # Sends a replace broadcast to the Receiver's stream, targeting the Sender's turbo frame to perform the form changes.
    broadcast_replace_later_to [self.receiver.id, self.sender.id], target: "user_#{self.sender.id}", partial: "users/friend_request_form", 
      locals: { logged_in_user: self.receiver, user: self.sender }
  end

  def prevent_duplicate_friend_requests
    if FriendRequest.exists?(sender: sender, receiver: receiver)
      errors.add(:sender, "you have already sent a friend request to #{sender.username}.")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender)
      errors.add(:sender, "you have already received a friend request from #{receiver.username}.")
    end
  end
end
