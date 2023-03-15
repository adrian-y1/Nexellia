# == Schema Information
#
# Table name: comments
#
#  id                  :bigint           not null, primary key
#  body                :text
#  comment_likes_count :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  post_id             :integer
#  user_id             :integer
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Validations" do
    describe "Body" do
      it "is valid when body is present" do
        comment = create(:comment)
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
end
