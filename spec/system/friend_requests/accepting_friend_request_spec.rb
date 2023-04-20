# This file contains system tests for accepting friend requests using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/friend_requests/accepting_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Accept Friend Request", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  #
  # Then, Accept the friend request by clicking the 'Accept' button after finding the Turbo Frame
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the flash notice, 'Friends' badge and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "users#index page" do
    # This test checks the functionality for accepting a friend request on the
    # users#index page using Turbo Streams.
    
    context "when clicking the Accept button on the users#index page" do
      it "successfully makes the two users friends on the users#index page using Turbo Streams" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        visit users_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        receiver_frame = find("turbo-frame#user_#{new_user.id}")
        within(receiver_frame) do
          click_on "Accept"
        end
        
        expect(page).to have_content("You and #{new_user.username} are now friends!")
        expect(page).to have_current_path(users_path)
        expect(page).to have_content("Friends")
      end
    end
  end

  describe "users#show page" do
    # This test checks the functionality for accepting a friend request on the
    # users#show page using Turbo Streams.
    
    context "when clicking the Accept button on the users#show page" do
      it "successfully makes the two users friends on the users#show page using Turbo Streams" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        visit user_path(new_user)
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        receiver_frame = find("turbo-frame#user_#{new_user.id}")
        within(receiver_frame) do
          click_on "Accept"
        end
        
        expect(page).to have_content("You and #{new_user.username} are now friends!")
        expect(page).to have_current_path(user_path(new_user))
        expect(page).to have_content("Friends")
      end
    end
  end
end
