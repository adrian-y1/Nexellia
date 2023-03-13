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
require "test_helper"

class PostLikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
