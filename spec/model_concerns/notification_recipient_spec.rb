require 'rails_helper'

RSpec.describe NotificationRecipient, type: :concern do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:post) { create(:post, user: author) }
  let(:comment) { create(:comment, user: user, post: post) }
  let(:comment_like) { create(:comment_like, liked_comment: comment, liker: author) }
  let(:post_like) { create(:post_like, liked_post: post, liker: user) }
  let(:friendship) { create(:friendship, user: user, friend: author) }
  let(:friend_request) { create(:friend_request, sender: user, receiver: author) }
  
  describe '#notification_recipient' do
    it "returns the post author as the notification recipient for a Comment" do
      expect(comment.notification_recipient).to eq(post.user)
    end

    it "returns the comment creator as the notification recipient for a CommentLike" do
      expect(comment_like.notification_recipient).to eq(comment.user)
    end

    it "returns the post author as the notification recipient for a PostLike" do
      expect(post_like.notification_recipient).to eq(post.user)
    end

    it "returns the friendship user as the notification recipient for a Friendship" do
      expect(friendship.notification_recipient).to eq(friendship.user)
    end

    it "returns the friend request receiver as the notification recipient for a FriendRequest" do
      expect(friend_request.notification_recipient).to eq(friend_request.receiver)
    end
  end
end