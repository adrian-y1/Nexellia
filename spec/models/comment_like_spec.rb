# == Schema Information
#
# Table name: comment_likes
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  liked_comment_id :integer
#  liker_id         :integer
#
require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  let(:user) { create(:user) }
  let(:comment) { create(:comment) }

  describe "Validations" do
    describe "Liker" do
      it "is valid when the liker & liked comment is unique" do
        comment_like = create(:comment_like, liker: user, liked_comment: comment)
        expect(comment_like).to be_valid
      end

      it "is not valid when the liker & liked comment is not unique" do
        comment_like1 = create(:comment_like, liker: user, liked_comment: comment)
        comment_like2 = build(:comment_like, liker: user, liked_comment: comment)
        expect(comment_like2).to_not be_valid
      end
    end
  end

  describe "Associations" do
    describe "User" do
      it "belongs to a user(liker)" do
        comment_like = create(:comment_like, liker: user)
        expect(comment_like.liker).to eq(user)
      end      
    end

    describe "Comment" do
      it "belongs to a comment(liked_comment)" do
        comment_like = create(:comment_like, liked_comment: comment)
        expect(comment_like.liked_comment).to eq(comment)
      end
    end
  end
end
