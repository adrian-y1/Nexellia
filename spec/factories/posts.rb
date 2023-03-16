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
FactoryBot.define do
  factory :post do
    user
    sequence(:body) { |n| "this is test number #{n}"}
  end
end
