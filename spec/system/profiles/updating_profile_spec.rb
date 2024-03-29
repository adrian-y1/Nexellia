# This file contains system tests for updating profiles using Turbo Frames & Turbo Stream Template. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/profiles/updating_profile_spec.rb

require 'rails_helper'

RSpec.describe "Update Profile", type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "Edit Profile Modal" do
    # These tests check that the modal itself is working.

    context "when clicking the edit button on the users#show page for profile information" do
      # This test ensures that the modal is opened when the user clicks the 'Edit' button
      # instead of being redirected to another page. Achieving this functionality required
      # the use of Turbo Frames.

      it "opens up the edit profile modal containing the edit profile form" do
        visit user_path(user)
        
        click_on "Edit Profile"

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")

        expect(edit_profile_modal_frame).to have_css('form')
        expect(edit_profile_modal_frame).to have_button("Save Profile")
      end
    end

    context "when clicking the cancel button inside the modal" do
      # This test ensures that the modal closes when the user clicks the 'Cancel' button
      
      it "closes the modal" do
        visit user_path(user)
        
        click_on "Edit Profile"

        edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
        expect(page).to have_css("turbo-frame#edit_profile_modal")
        
        find_button(class: "modal__header--close").click

        expect(page).to_not have_css("turbo-frame#edit_profile_modal")
      end
    end
  end

  describe "Update" do
    # These tests check invalid and valid form submissions associated with the profiles controller 

    describe "Valid Attributes" do
      # These tests ensures that the form is submitted successfully with valid attributes
      # and ensures profile information is updated for the current user without page reload/refresh. 
      #
      # Achieving this functionality required using Turbo Frames and a Turbo Stream Template 
      # that updates the _profile_information.html.erb partial whenever the user updates their profile.
      #
      # The DOM change without page reload can only be seen by the user making the change as it is 
      # not implemented with websockets/broadcasts.

      context "when clicking update profile button with valid attributes" do
        it "updates the profile without page reload just for the current user" do
          visit user_path(user)
  
          click_on "Edit Profile"
  
          edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
          within(edit_profile_modal_frame) do
            fill_in 'profile[public_email]', with: 'john@john'
            click_on 'Save Profile'
          end
  
          expect(page).to have_content('john@john')
          expect(page).to have_content('Profile information have been updated')
          expect(page).to have_current_path(user_path(user))
        end
      end
    end

    describe "Invalid Attributes" do
      # These tests ensures that the form is not submitted successfully with invalid attributes
      # and a an error message (flash alert) is displayed in the modal without page reload/refresh. 

      describe "Public Phone Number" do
        context "when the public phone number is not formatted correctly" do
          it "renders a flash alert error message inside the modal without page refresh/reload" do
            visit user_path(user)
    
            click_on "Edit Profile"
    
            edit_profile_modal_frame = find("turbo-frame#edit_profile_modal")
            within(edit_profile_modal_frame) do
              fill_in 'profile[public_phone_number]', with: '421sa321s23'
              click_on 'Save Profile'
            end
  
            expect(edit_profile_modal_frame).to have_content('Public phone number must be a valid 10-digit phone number')
            expect(page).to have_current_path(user_path(user))
          end
        end
      end
    end
  end

  describe "Unauthorized Access" do
    context "when a user tries to edit a profile that is not their own" do
      it "redirects to the posts#index page and renders an error message" do
        new_user = create(:user)
        visit edit_user_profile_path(new_user, new_user.profile)

        expect(page).to have_current_path(root_path)
        expect(page).to have_content('404! The page you requested was not found.')
      end
    end
  end
end