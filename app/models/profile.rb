# == Schema Information
#
# Table name: profiles
#
#  id              :bigint           not null, primary key
#  bio_description :text
#  first_name      :string
#  gender          :string
#  last_name       :string
#  public_email    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
  belongs_to :user
  
  validates :first_name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allowed letters" }, allow_blank: true
  validates :last_name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allowed letters" }, allow_blank: true
  validates :gender, inclusion: { in: ['Male', 'Female'], message: "%{value} is not a valid choice" }, allow_blank: true
  validates :bio_description, length: { maximum: 255 }
  validates :public_email, format: { with: Devise.email_regexp }, allow_blank: true
end
