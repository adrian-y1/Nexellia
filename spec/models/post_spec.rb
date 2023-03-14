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
  describe "Validation" do
    it "is valid when body is not blank and length < 255" do
      post = create(:post)
      expect(post.valid?).to be true
    end
  
    it "is not valid when body is blank" do
      post = build(:post, body: nil)
      expect(post.valid?).to be false
    end

    it "is not valid when body length > 255" do
      body = Faker::Lorem.characters(number: 275)
      post = build(:post, body: body)
      expect(post.valid?).to be false
    end
  end

  describe "Associations" do
    it "belongs to a user" do
      user = create(:user)
      post = create(:post, user: user)
      expect(post.user).to eq(user)
    end

    it "has many comments" do
      post = create(:post)
      comment1 = create(:comment, post: post)
      comment2 = create(:comment, post: post)
      expect(post.comments_count).to eq(2)
    end

    it "has many post likes" do
      post = create(:post)
      like1 = create(:post_like, liked_post: post)
      like2 = create(:post_like, liked_post: post)
      expect(post.post_likes_count).to eq(2)
    end

    it "has many likers" do 
      post = create(:post)
      like1 = create(:post_like, liked_post: post)
      like2 = create(:post_like, liked_post: post)
      expect(post.likers.count).to eq(2)
    end
  end
end
