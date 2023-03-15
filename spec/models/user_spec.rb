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
        user = create(:user)
        expect(user).to be_valid
      end

      it "is valid when email is unique" do
        user1 = create(:user, email: "michael@gmail.com")
        user2 = create(:user, email: "jim@gmail.com")
        expect(user2).to be_valid
      end

      it "is valid when email is formatted correctly" do
        user = create(:user)
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

        expect(user1.friends).to eq([user2, user3])
        expect(user2.friends).to eq([user1, user3])
        expect(user3.friends).to eq([user1, user2])
      end
    end

    describe "Post" do
      it "can have many posts" do
        user = create(:user)
        post1 = create(:post, user: user)
        post2 = create(:post, user: user)
        expect(user.posts.count).to eq(2)
      end
    end

    describe "PostLike" do
      it "can have many post likes" do
        user = create(:user)
        like1 = create(:post_like, liker: user)
        like2 = create(:post_like, liker: user)
        expect(user.post_likes.count).to eq(2)
      end

      it "can have many liked posts" do
        user = create(:user)
        like1 = create(:post_like, liker: user)
        like2 = create(:post_like, liker: user)
        expect(user.liked_posts.count).to eq(2)
      end
    end

    describe "Comment" do
      it "can have many comments" do
        user = create(:user)
        comment = create(:comment, user: user)
        expect(user.comments.count).to eq(1)
      end
    end

    describe "CommentLike" do
      it "can have many comment likes" do
        user = create(:user)
        comment_like = create(:comment_like, liker: user)
        expect(user.comment_likes.count).to eq(1)
      end

      it "can have many liked comments" do
        user = create(:user)
        comment_like = create(:comment_like, liker: user)
        expect(user.liked_comments.count).to eq(1)
      end
    end
  end

  describe "Instance Methods" do
    describe "#create_friendships" do
      it "creates a two-way friendship" do
        user1 = create(:user)
        user2 = create(:user)
        user1.create_friendship(user2)
        expect(user1.friends.first).to eq(user2)
        expect(user2.friends.first).to eq(user1)
      end
    end
  end
end
