require 'rails_helper'

RSpec.describe "User Sign up", type: :system do
  let(:first_name) { 'Michael' }
  let(:last_name) { 'Scott' }
  let(:email) { 'michael@gmail.com' }
  let(:password) { '12345678' }

  before do
    driven_by(:rack_test)
    visit new_user_registration_path
  end

  describe "Valid Attributes" do
    it "signs the user up" do
      fill_in 'user[first_name]', with: first_name
      fill_in 'user[last_name]', with: last_name
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button 'Sign up'
      expect(page).not_to have_current_path(new_user_registration_path)
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  describe "Invalid Attributes" do
    describe "First Name" do
      context "when first name is not provided" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: ''
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("First name can't be blank")
          expect(page).to have_content("First name must be between 2-30 characters")
        end
      end

      context "when first name length is < 2" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: 'v'
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("First name must be between 2-30 characters")
        end
      end

      context "when first name length is > 30" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: Faker::Lorem.characters(number: 35)
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("First name must be between 2-30 characters")
        end
      end

      context "when first name is not only letters" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: '32sdas32@3'
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("First name only allows letters")
        end
      end
    end

    describe "Last Name" do
      context "when last name is not provided" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: ''
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Last name can't be blank")
          expect(page).to have_content("Last name must be between 2-30 characters")
        end
      end

      context "when last name length is < 2" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: 'v'
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Last name must be between 2-30 characters")
        end
      end

      context "when last name length is > 30" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: Faker::Lorem.characters(number: 35)
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Last name must be between 2-30 characters")
        end
      end

      context "when last name is not only letters" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: '32sdas32@3'
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Last name only allows letters")
        end
      end
    end

    describe "Email" do
      context "when email is not provided" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Email can't be blank")
        end
      end

      context "when email is already taken" do
        before { create(:user, email: email) }

        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Email has already been taken")
        end
      end

      context "when email is not formatted correctly" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: "#{first_name}@"
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Email is invalid")
        end
      end
    end

    describe "Password" do
      context "when password is not provided" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Password can't be blank")
          expect(page).to have_content("Password confirmation doesn't match Password")
        end
      end

      context "when password length is < 6" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: '1234'
          fill_in 'user[password_confirmation]', with: '1234'
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Password is too short (minimum is 6 characters)")
        end
      end

      context "when password length is > 128" do
        let(:long_password) { Faker::Lorem.characters(number: 200) }

        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: long_password
          fill_in 'user[password_confirmation]', with: long_password
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Password is too long (maximum is 128 characters)")
        end
      end
    end

    describe "Password Confirmation" do
      context "when password and password confirmation don't match" do
        it "fails to sign the user up and shows error message" do
          fill_in 'user[first_name]', with: first_name
          fill_in 'user[last_name]', with: last_name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: 'okwqe'
          click_button 'Sign up'
          expect(page).to have_current_path(user_registration_path)
          expect(page).not_to have_current_path(new_user_registration_path)
          expect(page).to have_content("Password confirmation doesn't match Password")
        end
      end
    end
  end
end