# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  bio_description     :text
#  first_name          :string
#  gender              :string
#  last_name           :string
#  public_email        :string
#  public_phone_number :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "faker"

FactoryBot.define do
  factory :profile do
    user
    sequence(:bio_description) { |n| "Bio Description test number #{n}" }
    first_name { "John" }
    last_name { "Smith" }
    public_email { "john.smith@gmail.com" }
    gender { "Male" }
    public_phone_number { "1234567891" }
  end
end