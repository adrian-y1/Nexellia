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
require "test_helper"

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
