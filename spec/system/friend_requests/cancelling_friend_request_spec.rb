# This file contains system tests for cancelling friend requests. 
#
# These tests are created using Rspec + Capybara + Capybara's rack_test drive
#
# To run the tests, run => rspec spec/system/friend_requests/cancelling_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Cancel Friend Request", type: :system do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:rack_test)
  end

  describe "users#index page" do
    # This test checks the functionality for cancelling a friend request on the
    # users#index page.
    
    context "when clicking the cancel button on the users#index page" do
      it "cancels the friend request, renders a successfull flash notice message and redirects to the users#index page" do
        new_user = create(:user)
        create(:friend_request, sender: user, receiver: new_user)
        visit users_path
  
        click_on "Cancel"
  
        # The flash notice and the 'Add Friend' button ensure that the Friend Request object was
        # deleted, meaning the request has been cancelled
        expect(page).to have_content("Friend request to #{new_user.username} has been cancelled.")
        expect(page).to have_current_path(users_path)
        expect(page).to have_button("Add Friend")
      end
    end
  end
end