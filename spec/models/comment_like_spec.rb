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
  pending "add some examples to (or delete) #{__FILE__}"
end
