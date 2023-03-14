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

RSpec.describe Post, type: :model do
  it "is valid when body is not blank" do
    post = create(:post)
    expect(post.valid?).to be true
  end

  it "is not valid when body is blank" do
    post = build(:post, body: nil)
    expect(post.valid?).to be false
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_many(:post_likes) }
    it { should have_many(:likers) }
  end

  describe "Index" do
    it { should have_db_index(:user_id) }
  end
end
