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
require 'rails_helper'
require 'faker'

RSpec.describe Profile, type: :model do
  let(:profile) { create(:profile) }

  describe "Validation" do
    describe "first_name" do
      it "is valid when first name length is < 20" do
        expect(profile).to be_valid
      end

      it "is valid when first name length is exactly 20" do
        profile = create(:profile, first_name: 'AlexanderWilliamssss')
        expect(profile).to be_valid
      end

      it "is valid when first name is blank" do
        profile = create(:profile, first_name: '')
        expect(profile).to be_valid
      end
      
      it "is valid when first name contains only letters" do
        expect(profile).to be_valid
      end

      it "is not vaid when first name doesn't contain only letters" do
        profile = build(:profile, first_name: "13vik$41s")
        expect(profile).to_not be_valid
      end

      it "is not valid when first name length is > 20" do
        profile = build(:profile, first_name: "sdasdAsadasAasdasdasd")
        expect(profile).to_not be_valid
      end
    end

    describe "last_name" do
      it "is valid when last name length is < 20" do
        expect(profile).to be_valid
      end

      it "is valid when last name length is exactly 20" do
        profile = create(:profile, last_name: 'AlexanderWilliamssss')
        expect(profile).to be_valid
      end

      it "is valid when last name is blank" do
        profile = create(:profile, last_name: '')
        expect(profile).to be_valid
      end

      it "is valid when last name contains only letters" do
        expect(profile).to be_valid
      end

      it "is not vaid when last name doesn't contain only letters" do
        profile = build(:profile, last_name: "32*dsa3#4")
        expect(profile).to_not be_valid
      end

      it "is not valid when last name length is > 20" do
        profile = build(:profile, last_name: "sdasdAsadasAasdasdasd")
        expect(profile).to_not be_valid
      end
    end

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
      it "is representable when the picture is of .PNG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('avatar2.png', 'image/png'))
        expect(profile.picture).to be_representable
      end

      it "is representable when the picture is of .JPG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('testing_image.jpg', 'image/jpeg'))
        expect(profile.picture).to be_representable
      end

      it "is representable when the picture is of .JPEG content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('testing_image.jpeg', 'image/jpeg'))
        expect(profile.picture).to be_representable
      end

      it "is representable when the picture is of .GIF content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('test.gif', 'image/gif'))
        expect(profile.picture).to be_representable
      end

      it "is not representable when the picture is not of PNG, JPG, JPEG or GIF content type" do
        profile = create(:profile)
        profile.picture.attach(fixture_file_upload('text.txt', 'image/txt'))
        expect(profile.picture).not_to be_representable
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
