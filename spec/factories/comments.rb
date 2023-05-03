# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string
#  likes_count      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint
#  parent_id        :integer
#  user_id          :integer
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :post
    sequence(:body) { |n| "My Comment number -> #{n}" }
    
    trait :with_parent do
      association :parent, factory: :comment
    end
  end
end

