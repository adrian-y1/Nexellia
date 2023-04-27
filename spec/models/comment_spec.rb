# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  body        :text
#  likes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  post_id     :integer
#  user_id     :integer
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }
  
  describe "Validations" do
    describe "Body" do
      it "is valid when body is present" do
        expect(comment).to be_valid
      end

      it "is valid when body length is < 255" do
        body = Faker::Lorem.characters(number: 122)
        comment = create(:comment, body: body)
        expect(comment).to be_valid
      end

      it "is valid when body lenght is exactly 255" do
        body = Faker::Lorem.characters(number: 255)
        comment = create(:comment, body: body)
        expect(comment).to be_valid
      end

      it "is not valid when body is not present" do
        comment = build(:comment, body: nil)
        expect(comment).to_not be_valid
      end

      it "is not valid when body length is > 255" do
        body = Faker::Lorem.characters(number: 300)
        comment = build(:comment, body: body)
        expect(comment).to_not be_valid
      end
    end
  end

  describe "Association" do
    describe "User" do
      it "belongs to a user" do
        user = create(:user)
        comment = create(:comment, user: user)
        expect(comment.user).to eq(user)
      end
    end

    describe "Post" do
      it "belongs to a post" do
        post = create(:post)
        comment = create(:comment, post: post)
        expect(comment.post).to eq(post)
      end
    end

    describe "Like" do
      it "a comment can have many likes" do
        like = create(:like, likeable: comment)
        expect(comment.likes).to include(like)
      end
    end
  end
end
