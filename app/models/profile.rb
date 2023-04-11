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
class Profile < ApplicationRecord
  belongs_to :user
  
  has_one_attached :picture

  validates :first_name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, allow_blank: true
  validates :last_name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, allow_blank: true
  validates :gender, inclusion: { in: ['Male', 'Female'], message: "%{value} is not a valid choice" }, allow_blank: true
  validates :bio_description, length: { maximum: 255 }
  validates :public_email, format: { with: Devise.email_regexp }, allow_blank: true
  validates :public_phone_number, format: { with: /\A\d{10}\z/, message: "must be a valid 10-digit phone number" }, allow_blank: true

  def picture_thumbnail
    if picture.attached?
      picture.variant(resize_to_limit: [100, 100]).processed
    else
      'default.png'
    end
  end
end
