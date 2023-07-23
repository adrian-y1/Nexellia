# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  access_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  has_set_password       :boolean          default(FALSE)
#  last_name              :string
#  last_online_at         :datetime
#  posts_count            :integer          default(0)
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :string           default("offline"), not null
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "John" } 
    sequence(:last_name) { |n| "Doe" } 
    sequence(:password) { |n| "user_#{n}" } 
    sequence(:email) { |n| "user_#{n}@gmail.com" } 
  end
end
