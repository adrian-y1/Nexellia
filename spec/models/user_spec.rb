# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  access_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  posts_count            :integer          default(0)
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :string           default("offline"), not null
#  uid                    :string
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
    describe "first_name" do
      it "is valid when first name length is < 30" do
        expect(user).to be_valid
      end

      it "is valid when first name length is exactly 30" do
        user = create(:user, first_name: 'AlexanderssssssssssWilliamssss')
        expect(user).to be_valid
      end
      
      it "is valid when first name contains only letters" do
        expect(user).to be_valid
      end
      
      it "is not valid when first name is blank" do
        user = build(:user, first_name: '')
        expect(user).not_to be_valid
      end

      it "is not vaid when first name doesn't contain only letters" do
        user = build(:user, first_name: "13vik$41s")
        expect(user).to_not be_valid
      end

      it "is not valid when first name length is > 30" do
        user = build(:user, first_name: "sdasdsdasdasdasdAsadassadasdasdAasdasdasd")
        expect(user).to_not be_valid
      end

      it "is not valid when first name length is < 2" do
        user = build(:user, first_name: "a")
        expect(user).to_not be_valid
      end
    end

    describe "last_name" do
      it "is valid when last name length is < 30" do
        expect(user).to be_valid
      end

      it "is valid when last name length is exactly 30" do
        user = create(:user, last_name: 'AlexanderssssssssssWilliamssss')
        expect(user).to be_valid
      end
      
      it "is valid when last name contains only letters" do
        expect(user).to be_valid
      end
      
      it "is not valid when last name is blank" do
        user = build(:user, last_name: '')
        expect(user).not_to be_valid
      end

      it "is not vaid when last name doesn't contain only letters" do
        user = build(:user, last_name: "13vik$41s")
        expect(user).to_not be_valid
      end

      it "is not valid when last name length is > 30" do
        user = build(:user, last_name: "sdasdsdasdasdasdAsadassadasdasdAasdasdasd")
        expect(user).to_not be_valid
      end

      it "is not valid when last name length is < 2" do
        user = build(:user, last_name: "a")
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

    describe "Friendship" do
      it "can have many friends" do
        user1 = create(:user)
        user2 = create(:user)
        user3 = create(:user)
        create(:friendship, user: user1, friend: user2)
        create(:friendship, user: user1, friend: user3)
        expect(user1.friends).to include(user2, user3)
      end

      it "creates the friendship two-way" do
        user1 = create(:user)
        user2 = create(:user)
        create(:friendship, user: user1, friend: user2)
        expect(user1.friends).to include(user2)
        expect(user2.friends).to include(user1)
      end
    end

    describe "Post" do
      it "can have many posts" do
        post1 = create(:post, user: user)
        post2 = create(:post, user: user)
        expect(user.posts.count).to eq(2)
      end
    end

    describe "Like" do
      describe "posts" do
        it "can have many likes on posts" do
          like1 = create(:like, :post, user: user)
          like2 = create(:like, :post, user: user)
          expect(user.likes.count).to eq(2)
        end
  
        it "can have many liked posts" do
          like1 = create(:like, :post, user: user)
          like2 = create(:like, :post, user: user)
          liked_posts = user.likes.where(likeable_type: 'Post').count
          expect(liked_posts).to eq(2)
        end
      end

      describe "comments" do
        it "can have many likes on comments" do
          like2 = create(:like, :comment, user: user)
          like1 = create(:like, :comment, user: user)
          expect(user.likes.count).to eq(2)
        end
  
        it "can have many liked comments" do
          like1 = create(:like, :comment, user: user)
          like2 = create(:like, :comment, user: user)
          liked_comments = user.likes.where(likeable_type: "Comment").count
          expect(liked_comments).to eq(2)
        end
      end
    end

    describe "Comment" do
      it "can have many comments" do
        comment = create(:comment, user: user)
        expect(user.comments.count).to eq(1)
      end
    end
  end

  describe "Instance Methods" do
    let(:current_user) { create(:user) }
    let(:given_user) { create(:user) }

    describe "#full_name" do
      it "concatenates the first and last name and capitalises them" do
        new_user = create(:user, first_name: 'mike', last_name: 'smith')
        expect(new_user.full_name).to eq('Mike Smith')
      end
    end

    describe "#online?" do
      it "returns true when user's status is online" do
        current_user.update!(status: "online")
        is_online = current_user.online?
        expect(is_online).to be true
      end

      it "returns false when user's status is offline" do
        is_online = current_user.online?
        expect(is_online).to be false
      end
    end

    describe "#liked?" do
      describe "Post" do
        context "when the user has liked the given post" do
          it "returns true" do
            post = create(:post, user: given_user)
            current_user.like(post)
            liked = current_user.liked?(post)
            expect(liked).to be true
          end
        end
  
        context "when the user has not liked the given post" do
          it "returns false" do
            post = create(:post, user: given_user)
            liked = current_user.liked?(post)
            expect(liked).to be false
          end
        end
      end 

      describe "Comment" do
        context "when the user has liked the given comment" do
          it "returns true" do
            post = create(:post, user: given_user)
            comment = create(:comment, commentable: post, user: current_user)
            current_user.like(comment)
            liked = current_user.liked?(comment)
            expect(liked).to be true
          end
        end
  
        context "when the user has not liked the given comment" do
          it "returns false" do
            post = create(:post, user: given_user)
            comment = create(:comment, commentable: post, user: current_user)
            liked = current_user.liked?(comment)
            expect(liked).to be false
          end
        end
      end 
    end

    describe "#like" do
      describe "Post" do
        context "when the user has not liked the post before" do
          let(:post) { create(:post, user: given_user) }

          it "likes the post for the user" do
            current_user.like(post)
            expect(post.likes.last.user).to eq(current_user)
          end

          it "increments the likes of the post" do
            expect { current_user.like(post) }.to change { post.likes_count }.from(0).to(1)
          end
    
          it "calls #broadcast_likes_to_likeable" do
            expect(current_user).to receive(:broadcast_likes_to_likeable).with(post)
            current_user.like(post)
          end
        end

        context "when the user has liked the post before" do
          let(:post) { create(:post, user: given_user) }

          before do
            create(:like, likeable: post, user: current_user)
          end

          it "removes the user as one of the likers" do
            current_user.like(post)
            expect(post.likes.last).to be_nil
          end
 
          # Have to use .reload to reload the record from the database to assert the change
          it "decrements the likes of the post" do
            expect { current_user.like(post) }.to change { post.reload.likes_count }.from(1).to(0)
          end
    
          it "calls #broadcast_likes_to_likeable" do
            expect(current_user).to receive(:broadcast_likes_to_likeable).with(post)
            current_user.like(post)
          end
        end
      end

      describe "Comment" do
        context "when the user has not liked the comment before" do
          let(:post) { create(:post, user: given_user) }
          let(:comment) { create(:comment, commentable: post, user: current_user) }

          it "likes the post for the user" do
            current_user.like(comment)
            expect(comment.likes.last.user).to eq(current_user)
          end

          it "increments the likes of the comment" do
            expect { current_user.like(comment) }.to change { comment.likes_count }.from(0).to(1)
          end
    
          it "calls #broadcast_likes_to_likeable" do
            expect(current_user).to receive(:broadcast_likes_to_likeable).with(comment)
            current_user.like(comment)
          end
        end

        context "when the user has liked the comment before" do
          let(:post) { create(:post, user: given_user) }
          let(:comment) { create(:comment, commentable: post, user: current_user) }
          
          before do
            create(:like, likeable: comment, user: current_user)
          end

          it "removes the user as one of the likers of the comment" do
            current_user.like(comment)
            expect(comment.likes.last).to be_nil
          end
 
          # Have to use .reload to reload the record from the database to assert the change
          it "decrements the likes of the comment" do
            expect { current_user.like(comment) }.to change { comment.reload.likes_count }.from(1).to(0)
          end
    
          it "calls #broadcast_likes_to_likeable" do
            expect(current_user).to receive(:broadcast_likes_to_likeable).with(comment)
            current_user.like(comment)
          end
        end
      end
    end

    describe "#is_friends_with?" do
      context "when the current user is friends with the given user" do
        it "returns true" do
          create(:friendship, user: current_user, friend: given_user)
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
          create(:friendship, user: current_user, friend: given_user)
          can_send_friend_request = current_user.can_send_friend_request?(given_user)
          expect(can_send_friend_request).to be false
        end
      end
    end
  end
end
