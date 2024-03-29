require 'rails_helper'

RSpec.describe NotificationRecipient, type: :concern do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:post) { create(:post, user: author) }
  let(:comment) { create(:comment, user: user, commentable: post) }
  let(:comment_like) { create(:like, likeable: comment, user: author) }
  let(:post_like) { create(:like, likeable: post, user: user) }
  let(:friendship) { create(:friendship, user: user, friend: author) }
  let(:friend_request) { create(:friend_request, sender: user, receiver: author) }
  
  describe '#notification_recipient' do
    context "when a comment does not have a parent" do
      it "returns the post author as the notification recipient for a Comment" do
        expect(comment.notification_recipient).to eq(post.user)
      end
    end

    context "when a comment has a parent" do
      it "returns the parent comment creator as the notification recipient for a Comment reply" do
        reply_user = create(:user)
        reply = create(:comment, parent: comment, commentable: comment, user: reply_user)
        expect(reply.notification_recipient).to eq(comment.user)
      end
    end

    it "returns the comment creator as the notification recipient for a comment Like" do
      expect(comment_like.notification_recipient).to eq(comment.user)
    end

    it "returns the post author as the notification recipient for a post Like" do
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