# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comment_likes_count    :integer          default(0)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  post_likes_count       :integer          default(0)
#  posts_count            :integer          default(0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  
  describe "Validations" do
    describe "Username" do
      it "is valid when username length is between 3-15" do
        username = Faker::Lorem.characters(number: 12)
        user = build(:user, username: username)
        expect(user).to be_valid
      end
      
      it "is valid when username length is exactly 15" do
        username = Faker::Lorem.characters(number: 15)
        user = build(:user, username: username)
        expect(user).to be_valid
      end

      it "is valid when username is unique" do
        user1 = create(:user, username: "mark")
        user2 = build(:user, username: "jim")
        expect(user2).to be_valid
      end

      it "is not valid when username is not unique" do
        user1 = create(:user, username: "mark")
        user2 = build(:user, username: "mark")
        expect(user2).to_not be_valid
      end

      it "is not valid when username is not present" do
        user = build(:user, username: nil)
        expect(user).to_not be_valid
      end

      it "is not valid when username length is < 3" do
        user = build(:user, username: 'vi')
        expect(user).to_not be_valid
      end

      it "is not valid when username length is > 15 " do
        username = Faker::Lorem.characters(number: 20)
        user = build(:user, username: username)
        expect(user).to_not be_valid
      end


    end

    describe "Password" do
      it "is valid when password length is between 6-128" do
        password = Faker::Lorem.characters(number: 42)
        user = create(:user, password: password)
        expect(user).to be_valid
      end

      it "is valid when password length is exactly 128" do
        password = Faker::Lorem.characters(number: 128)
        user = create(:user, password: password)
        expect(user).to be_valid
      end

      it "is valid when password matches confirmation password" do
        password = "12345678"
        password_confirmation = "12345678"
        user = build(:user, password: password, password_confirmation: password_confirmation)
        expect(user).to be_valid
      end

      it "is not valid when password is not present" do
        user = build(:user, password: nil)
        expect(user).to_not be_valid
      end

      it "is not valid when password length is < 6" do
        password = Faker::Lorem.characters(number: 4)
        user = build(:user, password: password)
        expect(user).to_not be_valid
      end

      it "is not valid when password length is > 128" do
        password = Faker::Lorem.characters(number: 220)
        user = build(:user, password: password)
        expect(user).to_not be_valid
      end

      it "is not valid when password and password confirmation dont match" do
        password = "12345678"
        password_confirmation = "0987654"
        user = build(:user, password: password, password_confirmation: password_confirmation)
        expect(user).to_not be_valid
      end
    end

    describe "Email" do
      it "is valid when email is present" do
        expect(user).to be_valid
      end

      it "is valid when email is unique" do
        user1 = create(:user, email: "michael@gmail.com")
        user2 = create(:user, email: "jim@gmail.com")
        expect(user2).to be_valid
      end

      it "is valid when email is formatted correctly" do
        expect(user).to be_valid
      end

      it "is not valid when email is not present" do
        user = build(:user, email: nil)
        expect(user).to_not be_valid
      end

      it "is not valid when email is not unique" do
        user1 = create(:user, email: "michael@gmail.com")
        user2 = build(:user, email: "michael@gmail.com")
        expect(user2).to_not be_valid
      end

      it "is not valid when email is not formatted correctly" do
        user = build(:user, email: "jim@")
        expect(user).to_not be_valid
      end
    end
  end

  describe "Associations" do
    describe "FriendRequest" do
      it "can have many sent friend requests" do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)
        friend_request1 = create(:friend_request, sender: user1, receiver: user2)
        friend_request2 = create(:friend_request, sender: user1, receiver: user3)
        expect(user1.friend_requests_sent.count).to eq(2)
      end

      it "can have many received friend requests" do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)
        friend_request1 = create(:friend_request, sender: user1, receiver: user2)
        friend_request1 = create(:friend_request, sender: user3, receiver: user2)
        expect(user2.friend_requests_received.count).to eq(2)
      end
    end

    describe "friendship" do
      it "can create many friendships between users" do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)
        user1.friends << user2
        user1.friends << user3
        user2.friends << user3
        user2.friends << user1
        user3.friends << user1
        user3.friends << user2

        expect(user1.friends).to include(user2, user3)
        expect(user2.friends).to include(user1, user3)
        expect(user3.friends).to include(user1, user2)
      end
    end

    describe "Post" do
      it "can have many posts" do
        post1 = create(:post, user: user)
        post2 = create(:post, user: user)
        expect(user.posts.count).to eq(2)
      end
    end

    describe "PostLike" do
      it "can have many post likes" do
        like1 = create(:post_like, liker: user)
        like2 = create(:post_like, liker: user)
        expect(user.post_likes.count).to eq(2)
      end

      it "can have many liked posts" do
        like1 = create(:post_like, liker: user)
        like2 = create(:post_like, liker: user)
        expect(user.liked_posts.count).to eq(2)
      end
    end

    describe "Comment" do
      it "can have many comments" do
        comment = create(:comment, user: user)
        expect(user.comments.count).to eq(1)
      end
    end

    describe "CommentLike" do
      it "can have many comment likes" do
        comment_like = create(:comment_like, liker: user)
        expect(user.comment_likes.count).to eq(1)
      end

      it "can have many liked comments" do
        comment_like = create(:comment_like, liker: user)
        expect(user.liked_comments.count).to eq(1)
      end
    end
  end

  describe "Instance Methods" do
    let(:current_user) { create(:user) }
    let(:given_user) { create(:user) }

    describe "#create_friendships" do
      it "creates a two-way friendship" do
        current_user.create_friendship(given_user)
        expect(current_user.friends.first).to eq(given_user)
        expect(given_user.friends.first).to eq(current_user)
      end
    end

    describe "#is_friends_with?" do
      context "when the current user is friends with the given user" do
        it "returns true" do
          current_user.create_friendship(given_user)
          is_friends = current_user.is_friends_with?(given_user)
          expect(is_friends).to be true
        end
      end
      
      context "when the current user is not friends with the given user" do
        it "returns false" do
          is_friends = current_user.is_friends_with?(given_user)
          expect(is_friends).to be false
        end
      end
    end

    describe "#has_sent_friend_request_to?" do
      context "when the current user has sent a friend request to the given user" do
        it "returns true" do
          create(:friend_request, sender: current_user, receiver: given_user)
          has_sent_friend_request = current_user.has_sent_friend_request_to?(given_user)
          expect(has_sent_friend_request).to be true
        end
      end

      context "when the current user has not sent a friend request to the given user" do
        it "returns false" do
          has_sent_friend_request = current_user.has_sent_friend_request_to?(given_user)
          expect(has_sent_friend_request).to be false
        end
      end
    end

    describe "#has_received_friend_request_from?" do
      context "when the current user has received a friend request to the given user" do
        it "returns true" do
          create(:friend_request, sender: given_user, receiver: current_user)
          has_received_friend_request = current_user.has_received_friend_request_from?(given_user)
          expect(has_received_friend_request).to be true
        end
      end

      context "when the current user has not received a friend request to the given user" do
        it "returns false" do
          has_received_friend_request = current_user.has_received_friend_request_from?(given_user)
          expect(has_received_friend_request).to be false
        end
      end
    end

    describe "#can_send_friend_request?" do
      context "when the current user has not sent/received a friend request to/from the given user and they are not friends" do
        it "returns true" do
          can_send_friend_request = current_user.can_send_friend_request?(given_user)
        end
      end

      context "when the current user has received a friend request from the given user" do
        it "returns false" do
          create(:friend_request, sender: given_user, receiver: current_user)
          can_send_friend_request = current_user.can_send_friend_request?(given_user)
          expect(can_send_friend_request).to be false
        end
      end

      context "when the current user has sent a friend request to the given user" do
        it "returns false" do
          create(:friend_request, sender: current_user, receiver: given_user)
          can_send_friend_request = current_user.can_send_friend_request?(given_user)
          expect(can_send_friend_request).to be false
        end
      end

      context "when the current user is friends with the given user" do
        it "returns false" do
          current_user.create_friendship(given_user)
          can_send_friend_request = current_user.can_send_friend_request?(given_user)
          expect(can_send_friend_request).to be false
        end
      end
    end
  end
end
