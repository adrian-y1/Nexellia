# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  bio_description     :text
#  gender              :string
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
  attr_accessor :default
  
  belongs_to :user
  has_one_attached :picture, dependent: :destroy
  has_one_attached :cover_photo, dependent: :destroy

  validates :gender, inclusion: { in: ['Male', 'Female'], message: "%{value} is not a valid choice" }, allow_blank: true
  validates :bio_description, length: { maximum: 255 }
  validates :public_email, format: { with: Devise.email_regexp }, allow_blank: true
  validates :public_phone_number, format: { with: /\A\d{10}\z/, message: "must be a valid 10-digit phone number" }, allow_blank: true
  validate :content_type

  private
  
  def content_type
    validate_image_content_type(picture)
    validate_image_content_type(cover_photo)
  end
  
  def validate_image_content_type(image)
    return unless image.attached?
  
    acceptable_types = %w[image/jpeg image/jpg image/png image/gif]
    if !image.content_type.in?(acceptable_types)
      errors.add(image.name, "needs to be a JPEG, JPG, PNG or GIF")
    end
  end
end
