require 'rails_helper'

RSpec.describe NotificationClass, type: :concern do
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }
  let(:comment_like) { create(:like, :comment) }
  let(:post_like) { create(:like, :post) }
  let(:friendship) { create(:friendship) }
  let(:friend_request) { create(:friend_request) }

  describe '#notification_class' do
    it "returns the CommentNotification class for a Comment" do
      expect(comment.notification_class).to eq(CommentNotification)
    end

    it "returns the LikeNotification class for a post Like" do
      expect(post_like.notification_class).to eq(LikeNotification)
    end

    it "returns the LikeNotification class for a comment Like" do
      expect(comment_like.notification_class).to eq(LikeNotification)
    end

    it "returns the FriendshipNotification class for a Friendship" do
      expect(friendship.notification_class).to eq(FriendshipNotification)
    end

    it "returns the FriendRequestNotification class for a FriendRequest" do
      expect(friend_request.notification_class).to eq(FriendRequestNotification)
    end
  end
end