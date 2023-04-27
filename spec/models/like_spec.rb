# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  likeable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  likeable_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_likes_on_likeable                                   (likeable_type,likeable_id)
#  index_likes_on_user_id                                    (user_id)
#  index_likes_on_user_id_and_likeable_type_and_likeable_id  (user_id,likeable_type,likeable_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:comment) { create(:comment) }
  let(:post) { create(:post) }

  describe "Validations" do
    describe "User" do
      it "is valid when the user & the liked comment is unique" do
        like = create(:like, user: user, likeable: comment)
        expect(like).to be_valid
      end

      it "is not valid when the user & the liked comment is not unique" do
        like1 = create(:like, user: user, likeable: comment)
        like2 = build(:like, user: user, likeable: comment)
        expect(like2).to_not be_valid
      end

      it "is valid when the user & the liked post is unique" do
        like = create(:like, user: user, likeable: post)
        expect(like).to be_valid
      end

      it "is not valid when the user & the liked post is not unique" do
        like1 = create(:like, user: user, likeable: post)
        like2 = build(:like, user: user, likeable: post)
        expect(like2).to_not be_valid
      end
    end
  end

  describe "Associations" do
    describe "User" do
      it "belongs to a user" do
        like = create(:like, :comment, user: user)
        expect(like.user).to eq(user)
      end      
    end

    describe "Comment" do
      it "belongs to a comment" do
        like = create(:like, likeable: comment)
        expect(like.likeable).to eq(comment)
      end
    end

    describe "Post" do
      it "belongs to a post" do
        like = create(:like, likeable: post)
        expect(like.likeable).to eq(post)
      end
    end
  end
end
