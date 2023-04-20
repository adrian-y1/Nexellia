# This file contains system tests for sending friend requests using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/friend_requests/sending_friend_request_spec.rb

require "rails_helper"

RSpec.describe "Send Friend Request", type: :system , js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected to avoid flaky tests
  # whereby Turbo Stream broadcasts happen before turbo_stream_from can establish a websocket connection.
  #
  # Then, send the friend request by clicking the 'Add Friend' button after finding the Turbo Frame
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the flash notice, 'Cancel' button and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "users#index page" do
    # This test checks the functionality for sending a friend request on the
    # users#index using Turbo Streams.
    
    context "when clicking the add friend button on the users#index page" do
      it "successfully sends a friend request on users#index  using Turbo Streams" do
        new_user = create(:user)
        visit users_path

        # To avoid flaky tests, this expectation must be asserted to check that the subscription
        # has been connected to the stream before making a broadcast call.
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        receiver_frame = find("turbo-frame#user_#{new_user.id}")
        within(receiver_frame) do
          click_on "Add Friend"
        end

        # The flash notice, the 'Cancel' button and the current path, ensure that the Friend Request object was
        # created, meaning the request was sent to the user in real-time using Turbo Streams.
        expect(page).to have_content("Friend request has been sent to #{new_user.username}!")
        expect(page).to have_current_path(users_path)
        expect(page).to have_button("Cancel")
      end
    end
  end

  describe "users#show page" do
    # This test checks the functionality for sending a friend request on the
    # users#show using Turbo Streams.
    
    context "when clicking the add friend button on the users#show page" do
      it "successfully sends a friend request on users#show  using Turbo Streams" do
        new_user = create(:user)
        visit user_path(new_user)

        # To avoid flaky tests, this expectation must be asserted to check that the subscription
        # has been connected to the stream before making a broadcast call.
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        receiver_frame = find("turbo-frame#user_#{new_user.id}")
        within(receiver_frame) do
          click_on "Add Friend"
        end

        # The flash notice, the 'Cancel' button and the current path, ensure that the Friend Request object was
        # created, meaning the request was sent to the user in real-time using Turbo Streams.
        expect(page).to have_content("Friend request has been sent to #{new_user.username}!")
        expect(page).to have_current_path(user_path(new_user))
        expect(page).to have_button("Cancel")
      end
    end
  end
end