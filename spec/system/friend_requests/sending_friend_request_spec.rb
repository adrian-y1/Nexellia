# This file contains system tests for sending friend requests. 
#
# These tests are created using Rspec + Capybara + Capybara's rack_test drive
#
# To run the tests, run => rspec spec/system/friend_requests/sending_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Send Friend Request", type: :system do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:rack_test)
  end

  describe "users#index page" do
    # This test checks the functionality for sending a friend request on the
    # users#index page.
    
    context "when clicking the add friend button on the users#index page" do
      it "renders a successfull flash notice message and redirects to the users#index page" do
        new_user = create(:user)
        visit users_path
  
        click_on "Add Friend"
  
        # The flash notice and the 'Cancel' button ensure that the Friend Request object was
        # created, meaning the request was sent to the user
        expect(page).to have_content("Friend request has been sent to #{new_user.username}!")
        expect(page).to have_current_path(users_path)
        expect(page).to have_button("Cancel")
      end
    end
  end
end