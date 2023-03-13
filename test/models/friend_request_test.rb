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
require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
