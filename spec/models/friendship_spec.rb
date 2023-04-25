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
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  describe "Validation" do
    context "when the two users are not friends" do
      it "successfully creates the two-way friendship and friendship is valid" do
        friendship = create(:friendship, user: user, friend: friend)
        expect(friendship).to be_valid
      end
    end

    context "when the two users are already friends" do
      it "doesn't create the two-way friendship and is invalid" do
        friendship = create(:friendship, user: user, friend: friend)
        new_friendship = build(:friendship, user: user, friend: friend)
        expect(new_friendship).not_to be_valid
      end
    end
  end

  describe "Association" do
    describe "User" do
      let(:friendship) { create(:friendship, user: user, friend: friend) }

      it "belongs to a user(user)" do
        expect(friendship.user).to eq(user)
      end

      it "belongs to a user(friend)" do
        expect(friendship.friend).to eq(friend)
      end
    end
  end
end
