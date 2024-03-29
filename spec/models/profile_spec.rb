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
require 'rails_helper'
require 'faker'

RSpec.describe Profile, type: :model do
  let(:profile) { create(:profile) }

  describe "Validation" do
    describe "gender" do
      it "is valid when the chosen gender is Male" do
        expect(profile).to be_valid
      end

      it "is valid when the chosen gender is Female" do
        profile = create(:profile, gender: "Female")
        expect(profile).to be_valid
      end

      it "is valid when no gender has been chosen" do
        profile = create(:profile, gender: "")
        expect(profile).to be_valid
      end

      it "is not valid when the gender is not Male or Female or left blank" do
        profile = build(:profile, gender: "custom")
        expect(profile).to_not be_valid
      end
    end

    describe "bio_description" do
      it "is valid when bio description length is < 255" do
        expect(profile).to be_valid
      end

      it "is valid when bio description length is exactly 255" do
        bio_description = Faker::Lorem.characters(number: 255)
        profile = create(:profile, bio_description: bio_description)
        expect(profile).to be_valid
      end

      it "is valid when bio description is blank" do
        profile = create(:profile, bio_description: '')
        expect(profile).to be_valid
      end

      it "is not valid when bio description length is > 255" do
        bio_description = Faker::Lorem.characters(number: 350)
        profile = build(:profile, bio_description: bio_description)
        expect(profile).to_not be_valid
      end
    end

    describe "public_email" do
      it "is valid when public email is formatted correctly" do
        expect(profile).to be_valid
      end

      it "is valid when public email is blank" do
        profile = create(:profile, public_email: nil)
        expect(profile).to be_valid
      end

      it "is not valid when public email is not formatted correctly" do
        profile = build(:profile, public_email: "jim@")
        expect(profile).to_not be_valid
      end
    end

    describe "public_phone_number" do
      it "is valid when public phone number is exactly 10 digits" do
        expect(profile).to be_valid
      end

      it "is valid when public phone number is formatted correctly" do
        expect(profile).to be_valid
      end

      it "is valid when public phone number is blank" do
        profile = build(:profile, public_phone_number: '')
        expect(profile).to be_valid
      end

      it "is not valid when public phone number is > 10 digits" do
        public_phone_number = "1234567891032"
        profile = build(:profile, public_phone_number: public_phone_number)
        expect(profile).to_not be_valid
      end

      it "is not valid when public phone number is < 10 digits" do
        public_phone_number = "1234567"
        profile = build(:profile, public_phone_number: public_phone_number)
        expect(profile).to_not be_valid
      end

      it "is not valid when public phone number is not formatted correctly" do
        public_phone_number = "123-456-789-1"
        profile = build(:profile, public_phone_number: public_phone_number)
        expect(profile).to_not be_valid
      end
    end

    describe "picture" do
      it "is valid when the picture is of .PNG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('avatar2.png', 'image/png'))
        expect(profile).to be_valid
      end

      it "is valid when the picture is of .JPG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('testing_image.jpg', 'image/jpeg'))
        expect(profile).to be_valid
      end

      it "is valid when the picture is of .JPEG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('testing_image.jpeg', 'image/jpeg'))
        expect(profile).to be_valid
      end

      it "is valid when the picture is of .GIF content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('test.gif', 'image/gif'))
        expect(profile).to be_valid
      end

      it "is not valid when the picture is not of PNG, JPG, JPEG or GIF content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('text.txt', 'image/txt'))
        expect(profile).not_to be_valid
      end
    end

    describe "cover photo" do
      it "is valid when the cover photo is of .PNG content type" do
        profile = create(:profile)
        profile.cover_photo.attach(fixture_file_upload('avatar2.png', 'image/png'))
        expect(profile).to be_valid
      end

      it "is valid when the cover photo is of .JPG content type" do
        profile = create(:profile)
        profile.cover_photo.attach(fixture_file_upload('testing_image.jpg', 'image/jpeg'))
        expect(profile).to be_valid
      end

      it "is valid when the cover photo is of .JPEG content type" do
        profile = create(:profile)
        profile.cover_photo.attach(fixture_file_upload('testing_image.jpeg', 'image/jpeg'))
        expect(profile).to be_valid
      end

      it "is valid when the cover photo is of .GIF content type" do
        profile = create(:profile)
        profile.cover_photo.attach(fixture_file_upload('test.gif', 'image/gif'))
        expect(profile).to be_valid
      end

      it "is not valid when the cover photo is not of PNG, JPG, JPEG or GIF content type" do
        profile = create(:profile)
        profile.cover_photo.attach(fixture_file_upload('text.txt', 'image/txt'))
        expect(profile).not_to be_valid
      end
    end
  end

  describe "Association" do
    describe "User" do
      it "belongs to a user" do
        user = create(:user)
        profile = create(:profile, user: user)
        expect(profile.user).to eq(user)
      end
    end
  end
end
