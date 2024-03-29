# This file contains system tests for uploading profile pictures using ActiveStorage, Turbo Frames, Turbo Stream Template & Stimulus. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/profiles/uploading_profile_picture_spec.rb

require 'rails_helper'

RSpec.describe "Upload Profile Picture", type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "image-preview stimulus controller" do
    # These tests check that the image preview functionality implemented in the image-preview
    # stimulus controller works. 
    
    # This test ensures that when the user chooses an image without updating the profile,
    # their new profile picture is displayed to show them what they have selected, along with the
    # new-picture-container div element.
    context "when the user has selected an image" do
      it "displays the new-picture-container div and the selected image" do
        visit user_path(user)
  
        click_on "Edit Profile"

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        expect(edit_profile_modal_frame).to_not have_css('[class="new-picture-container"]')

        within(edit_profile_modal_frame) do
          attach_file('profile[picture]', 'spec/fixtures/files/avatar2.png', visible: false)
        end
        
        expect(edit_profile_modal_frame).to have_css('[class="new-picture-container profile-form__pp"]')
        expect(edit_profile_modal_frame).to have_css('img[data-image-preview-target="newPicture"]')
      end
    end

    # This test ensures that when the user doesn't select an image, the new-picture-container div element 
    # is not visible on the page
    context "when the user has not selected an image" do
      it "does not display new-picture-container div" do
        visit user_path(user)
  
        click_on "Edit Profile"

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        expect(edit_profile_modal_frame).to_not have_css('[class="new-picture-container"]')
        expect(edit_profile_modal_frame).to_not have_css('img[data-image-preview-target="newPicture"]')
      end
    end
  end

  describe "Update" do
    # These tests check the functionality of uploading profile pictures with valid and invalid
    # form submissions using Turbo Frames and Turbo Streams Template.

    describe "Valid Submission" do
      # These tests ensures that when the user selects a new image and updates their profile with valid attributes,
      # their old profile picture is updated with the new one without page refresh/reload using
      # Turbo Frames and Turbo Streams.
      
      context "when updating a profile with a valid field and selecting an image" do
        it "updates the profile picture and displays success message using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/avatar2.png', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src$="avatar2.png"]')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end
      
      context "when the file type is .PNG" do
        it "updates the profile picture using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/avatar2.png', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src$="avatar2.png"]')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end

      context "when the file type is .JPG" do
        it "updates the profile picture using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/testing_image.jpg', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src$="testing_image.jpg"]')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end

      context "when the file type is .JPEG" do
        it "updates the profile picture using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/testing_image.jpeg', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src$="testing_image.jpeg"]')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end

      context "when the file type is .GIF" do
        it "updates the profile picture using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/test.gif', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src$="test.gif"]')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end
    end

    describe "Invalid Submission" do
      # This test ensures that when the user selects a new image and updates their profile with invalid attributes,
      # an error message is displayed for the invalid field, their profile picture remains unchanged,
      # and the selected image is removed, all done without page refresh/reload using
      # Turbo Frames and Turbo Streams.

      context "when the file type is not PNG, JPG, JPEG or GIF" do
        it "removes the selected image and displays error message using Turbo Stream Template" do
          visit user_path(user)
  
          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
  
          click_on "Edit Profile"

          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            attach_file('profile[picture]', 'spec/fixtures/files/text.txt', visible: false)
            click_on "Save Profile"
          end

          expect(page).to have_css('img[src*="https://secure.gravatar.com/avatar/"]')
          expect(page).to_not have_css('img[src$="text.txt"]')
          expect(page).to have_current_path(user_path(user))
        end
      end
    end
  end
end