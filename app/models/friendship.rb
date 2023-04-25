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
end
