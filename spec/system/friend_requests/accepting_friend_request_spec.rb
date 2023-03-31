# This file contains system tests for accepting friend requests. 
#
# These tests are created using Rspec + Capybara + Capybara's rack_test drive
#
# To run the tests, run => rspec spec/system/friend_requests/accepting_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Accept Friend Request", type: :system do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:rack_test)
  end

  describe "users#index page" do
    # This test checks the functionality for accepting a friend request on the
    # users#index page.
    
    context "when clicking the Accept button on the users#index page" do
      it "creates the friendship, renders a successfull flash notice message and redirects to the users#index page" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        visit users_path
  
        click_on "Accept"
  
        # The flash notice ensures the two users are now friends along with the expectation
        # of not being able to find the sender's id on the page for the "Accept" form
        expect(page).to have_content("You and #{new_user.username} are now friends!")
        expect(page).to have_current_path(users_path)
        expect(page).to_not have_content("#{new_user.id}")
      end
    end
  end
end