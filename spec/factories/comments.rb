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
FactoryBot.define do
  factory :comment do
    post
    user
    sequence(:body) { |n| "My Comment number -> #{n}" }
  end
end
