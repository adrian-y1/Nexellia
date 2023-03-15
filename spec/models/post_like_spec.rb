# == Schema Information
#
# Table name: post_likes
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  liked_post_id :integer
#  liker_id      :integer
#
# Indexes
#
#  index_post_likes_on_liker_id_and_liked_post_id  (liker_id,liked_post_id) UNIQUE
#
require 'rails_helper'

RSpec.describe PostLike, type: :model do
  describe "Validations" do
    describe "Liker" do
      it "is valid when the liker & liked post is unique" do
        user = create(:user)
        post = create(:post)
        post_like = create(:post_like, liker: user, liked_post: post)
        expect(post_like).to be_valid
      end

      it "is not valid when the liker & liked post is not unique" do
        user = create(:user)
        post = create(:post)
        post_like1 = create(:post_like, liker: user, liked_post: post)
        post_like2 = build(:post_like, liker: user, liked_post: post)
        expect(post_like2).to_not be_valid
      end
    end
  end

  describe "Associations" do
    describe "User" do
      it "belongs to a user(liker)" do
        user = create(:user)
        post_like = create(:post_like, liker: user)
        expect(post_like.liker).to eq(user)
      end      
    end

    describe "Post" do
      it "belongs to a post(liked_post)" do
        post = create(:post)
        post_like = create(:post_like, liked_post: post)
        expect(post_like.liked_post).to eq(post)
      end
    end
  end
end
