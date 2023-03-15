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
  describe "Association" do
    describe "User" do
      it "belongs to a user(sender)" do
        sender = create(:user)
        receiver = create(:user)
        friend_request = create(:friend_request, sender: sender, receiver: receiver)
        expect(friend_request.sender).to eq(sender)
      end

      it "belongs to a user(receiver)" do
        sender = create(:user)
        receiver = create(:user)
        friend_request = create(:friend_request, sender: sender, receiver: receiver)
        expect(friend_request.receiver).to eq(receiver)
      end
    end
  end
end
