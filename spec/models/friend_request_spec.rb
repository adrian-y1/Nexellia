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
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
