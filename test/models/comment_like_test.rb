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
require "test_helper"

class CommentLikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
