# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  likes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
require 'rails_helper'
require 'faker'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  describe "Validation" do
    describe "Body" do
      it "is valid when body is not blank and length < 255" do
        expect(post).to be_valid
      end
    
      it "is not valid when body is blank" do
        post = build(:post, body: nil)
        expect(post).to_not be_valid
      end
  
      it "is not valid when body length > 255" do
        body = Faker::Lorem.characters(number: 275)
        post = build(:post, body: body)
        expect(post).to_not be_valid
      end
    end

    describe "Image" do
      it "is valid when the image is of .PNG content type" do
        post = create(:post)
        post.image.attach(fixture_file_upload('avatar2.png', 'image/png'))
        expect(post).to be_valid
      end

      it "is valid when the image is of .JPG content type" do
        post = create(:post)
        post.image.attach(fixture_file_upload('testing_image.jpg', 'image/jpeg'))
        expect(post).to be_valid
      end

      it "is valid when the image is of .JPEG content type" do
        post = create(:post)
        post.image.attach(fixture_file_upload('testing_image.jpeg', 'image/jpeg'))
        expect(post).to be_valid
      end

      it "is valid when the image is of .GIF content type" do
        post = create(:post)
        post.image.attach(fixture_file_upload('test.gif', 'image/gif'))
        expect(post).to be_valid
      end

      it "is valid when no image is provided" do
        post = create(:post)
        expect(post).to be_valid
      end

      it "is not valid when the image is not of PNG, JPG, JPEG or GIF content type" do
        post = create(:post)
        post.image.attach(fixture_file_upload('text.txt', 'image/txt'))
        expect(post).not_to be_valid
      end
    end
  end

  describe "Associations" do
    describe "User" do
      it "belongs to a user" do
        user = create(:user)
        post = create(:post, user: user)
        expect(post.user).to eq(user)
      end
    end

    describe "Comment" do
      it "can have many comments" do
        comment1 = create(:comment, post: post)
        comment2 = create(:comment, post: post)
        expect(post.comments_count).to eq(2)
      end
    end

    describe "Like" do
      before do
        create(:like, likeable: post)
        create(:like, likeable: post)
      end

      it "can have many post likes" do
        expect(post.likes_count).to eq(2)
      end
    end
  end
end
