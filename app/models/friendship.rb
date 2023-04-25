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
  validates :user, uniqueness: { scope: :friend_id, message: "already friends" }

  belongs_to :user
  belongs_to :friend, class_name: "User"

  after_create :create_inverse_friendship
  before_destroy :destroy_notifications
  after_destroy :destroy_inverse_friendship

  after_create_commit do 
    create_notification
  end

  private

  def create_notification
    FriendshipNotification.with(message: self).deliver_later(user)
  end

  # Destroys all notifications associated with this friend request
  def destroy_notifications
    notifications = Notification.where(recipient_id: user, type: "FriendshipNotification", params: { message: self })
    notifications.destroy_all
  end

  def create_inverse_friendship
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_friendship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end
end
