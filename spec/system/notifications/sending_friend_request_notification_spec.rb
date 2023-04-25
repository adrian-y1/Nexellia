# This file contains system tests for real-time notifications for sending a friend request using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/sending_friend_request_notification_spec.rb

require 'rails_helper'

RSpec.describe "Sending Friend Request Notification", type: :system, js: true do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }

  before do
    login_as(receiver)
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for sending a real-time notification to the friend request receiver when a 
  # user sends them a friend request. They also check if the notification is prepended to the correct 
  # element (the dropdown notifications list or the unread notification in the flash section)
  #
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a friend request and find the Turbo Frame tag associated with the receiver.
  #
  # Lastly, the expectations for the notification and the current path, ensures
  # that the receiver is receiving the notification in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "Notifications Dropdown List" do
    context "when a user sends a friend request" do
      it "sends a real-time notification to the friend request receiver and prepends it to their dropdown notifications list" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:friend_request, sender: sender, receiver: receiver)

        find(:id, 'notificationsDropdown').click

        all_notifications_frame = find("turbo-frame#all_notifications_#{receiver.id}")

        expect(all_notifications_frame).to have_content("#{sender.username}\nsent you a friend request")
        expect(page).to have_current_path(posts_path)
      end
    end
  end  

  describe "Unread Notification" do
    context "when a user sends a friend request" do
      it "sends a real-time notification to the friend request receiver and displays it at the top of the page" do
        visit user_path(receiver)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:friend_request, sender: sender, receiver: receiver)

        notifications_frame = find("turbo-frame#notifications")
        within(notifications_frame) do
          unread_notifications_frame = find("turbo-frame#unread_notifications_#{receiver.id}")
          expect(unread_notifications_frame).to have_content("#{sender.username} sent you a friend request")
        end

        expect(page).to have_current_path(user_path(receiver))
      end
    end
  end  
end