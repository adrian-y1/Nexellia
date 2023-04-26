require 'rails_helper'

RSpec.describe NotificationClass, type: :concern do
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }
  let(:comment_like) { create(:comment_like) }
  let(:post_like) { create(:post_like) }
  let(:friendship) { create(:friendship) }
  let(:friend_request) { create(:friend_request) }

  describe '#notification_class' do
    it "returns the CommentNotification class for a Comment" do
      expect(comment.notification_class).to eq(CommentNotification)
    end

    it "returns the CommentLikeNotification class for a CommentLike" do
      expect(comment_like.notification_class).to eq(CommentLikeNotification)
    end

    it "returns the PostLikeNotification class for a PostLike" do
      expect(post_like.notification_class).to eq(PostLikeNotification)
    end

    it "returns the FriendshipNotification class for a Friendship" do
      expect(friendship.notification_class).to eq(FriendshipNotification)
    end

    it "returns the FriendRequestNotification class for a FriendRequest" do
      expect(friend_request.notification_class).to eq(FriendRequestNotification)
    end
  end
end