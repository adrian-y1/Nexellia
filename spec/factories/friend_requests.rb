# == Schema Information
#
# Table name: friend_requests
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :integer
#  sender_id   :integer
#
FactoryBot.define do
  factory :friend_request do
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
