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
FactoryBot.define do
  factory :comment_like do
    association :liker, factory: :user
    association :liked_comment, factory: :comment
  end
end
