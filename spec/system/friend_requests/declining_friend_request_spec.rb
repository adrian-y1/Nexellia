# This file contains system tests for declining friend requests. 
#
# These tests are created using Rspec + Capybara + Capybara's rack_test drive
#
# To run the tests, run => rspec spec/system/friend_requests/declining_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Decline Friend Request", type: :system do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:rack_test)
  end

  describe "users#index page" do
    # This test checks the functionality for declining a friend request on the
    # users#index page.
    
    context "when clicking the Decline button on the users#index page" do
      it "declines the request, renders a successfull flash notice message and redirects to the users#index page" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        visit users_path
  
        click_on "Decline"
  
        # The flash notice and the 'Add Friend' button ensure that the Friend Request object was
        # deleted, meaning the request has been declined
        expect(page).to have_content("You have declined #{new_user.username}'s friend request.")
        expect(page).to have_current_path(users_path)
        expect(page).to have_button("Add Friend")
      end
    end
  end
end