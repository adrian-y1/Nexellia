# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  body             :text
#  comments_count   :integer          default(0)
#  post_likes_count :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
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

    describe "PostLike" do
      before do
        create(:post_like, liked_post: post)
        create(:post_like, liked_post: post)
      end

      it "can have many post likes" do
        expect(post.post_likes_count).to eq(2)
      end

      it "can have many likers" do 
        expect(post.likers.count).to eq(2)
      end
    end
  end
end
