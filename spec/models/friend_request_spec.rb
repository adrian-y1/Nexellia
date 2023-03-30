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
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }
  let(:friend_request) { create(:friend_request, sender: sender, receiver: receiver) }
  
  describe "Association" do
    describe "User" do
      it "belongs to a user(sender)" do
        expect(friend_request.sender).to eq(sender)
      end

      it "belongs to a user(receiver)" do
        expect(friend_request.receiver).to eq(receiver)
      end
    end
  end
end
