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

  private

  def prevent_duplicate_friend_requests
    if FriendRequest.exists?(sender: sender, receiver: receiver)
      errors.add(:sender, "you have already sent a friend request to #{sender.username}.")
    elsif FriendRequest.exists?(sender: receiver, receiver: sender)
      errors.add(:sender, "you have already received a friend request from #{receiver.username}.")
    end
  end
end
