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
  end
end
