# This file contains system tests for cancelling friend requests using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/friend_requests/cancelling_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Cancel Friend Request", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "users#index page" do
    # This test checks the functionality for cancelling a friend request on the
    # users#index page using Turbo Streams.
    
    context "when clicking the cancel button on the users#index page" do
      # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
      #
      # Then, cancel the friend request by clicking the 'Cancel' button after finding the Turbo Frame
      # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
      #
      # Lastly, the expectations for the flash notice, 'Add Friend' button and the current path, ensures
      # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
      # Meaning Turbo Streams is working.

      it "successfully cancels the friend request on the users#index page using Turbo Streams" do
        new_user = create(:user)
        create(:friend_request, sender: user, receiver: new_user)
        visit users_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        receiver_frame = find("turbo-frame#user_#{new_user.id}")
        within(receiver_frame) do
          click_on "Cancel"
        end
        
        expect(page).to have_content("Friend request to #{new_user.username} has been cancelled.")
        expect(page).to have_current_path(users_path)
        expect(page).to have_button("Add Friend")
      end
    end
  end
end