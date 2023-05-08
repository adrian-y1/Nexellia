# This file contains system tests for uploading profile cover photos using ActiveStorage, Turbo Frames, & Turbo Stream Template. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/profiles/uploading_cover_photo_spec.rb

require 'rails_helper'

RSpec.describe "Upload Cover Photo", type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "Valid Submission" do
    # These tests ensures that when the user selects a new cover photo and updates their profile with valid attributes,
    # their old cover photo is updated with the new one without page refresh/reload using
    # Turbo Frames and Turbo Streams.
    
    context "when updating a profile with a valid field and selecting a cover photo" do
      it "updates the cover photo and displays success message using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/avatar2.png')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src$="avatar2.png"]')
        expect(page).to have_content('Profile information have been updated')
        expect(page).to have_current_path(user_path(user))
      end
    end
    
    context "when the file type is .PNG" do
      it "updates the cover photo using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"]')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/avatar2.png')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src$="avatar2.png"]')
        expect(page).to have_content('Profile information have been updated')
        expect(page).to have_current_path(user_path(user))
      end
    end

    context "when the file type is .JPG" do
      it "updates the cover photo using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"]')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/testing_image.jpg')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src$="testing_image.jpg"]')
        expect(page).to have_content('Profile information have been updated')
        expect(page).to have_current_path(user_path(user))
      end
    end

    context "when the file type is .JPEG" do
      it "updates the cover photo using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"]')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/testing_image.jpeg')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src$="testing_image.jpeg"]')
        expect(page).to have_content('Profile information have been updated')
        expect(page).to have_current_path(user_path(user))
      end
    end

    context "when the file type is .GIF" do
      it "updates the cover photo using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"]')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/test.gif')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src$="test.gif"]')
        expect(page).to have_content('Profile information have been updated')
        expect(page).to have_current_path(user_path(user))
      end
    end
  end

  describe "Invalid Submission" do
    # This test ensures that when the user selects a new image and updates their profile with invalid attributes,
    # an error message is displayed for the invalid field, their cover photo remains unchanged,
    # and the selected image is removed, all done without page refresh/reload using
    # Turbo Frames and Turbo Streams.

    context "when the file type is not PNG, JPG, JPEG or GIF" do
      it "removes the selected cover photo and displays error message using Turbo Stream Template" do
        visit user_path(user)

        expect(page).to have_css('img[src*="default_cover_photo"]')

        profile_information_frame = find("turbo-frame#profile_information")
        within(profile_information_frame) do
          click_on "Edit"
        end

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        within(edit_profile_modal_frame) do
          attach_file('profile[cover_photo]', 'spec/fixtures/files/text.txt')
          click_on "Update Profile"
        end

        expect(page).to have_css('img[src*="default_cover_photo"]')
        expect(page).to_not have_css('img[src$="text.txt"]')
        expect(page).to have_current_path(user_path(user))
      end
    end
  end
end