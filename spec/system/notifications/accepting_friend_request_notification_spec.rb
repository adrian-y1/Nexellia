# This file contains system tests for real-time notifications for accepting a friend request using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/accepting_friend_request_notification_spec.rb

require 'rails_helper'

RSpec.describe "Accepting Friend Request Notification", type: :system, js: true do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for sending a notification to both users in real-time when the
  # friend request receiver accepts the friend request. They also check if the notification is prepended to the correct 
  # element (the dropdown notifications list or the new notifications in the flash section)
  #
  # With the help of Capybara's #using_session helper, we can login both the sender and receiver simultaneously
  # in two different sessions. This will help determine that they both receive the notification in real-time without
  # reloading the page and whatnot.
  #
  # First, login the receiver in a session and ensure that the subscription to the stream has been 
  # connected before the broadcast gets called to avoid flaky tests. Same goes for the sender.
  #
  # Then, inside the receiver's session, accept the friend request and find the Turbo Frame tag associated with the receiver.
  # The expectations for the notification and the current path, ensures that the receiver is receiving 
  # the notification in real-time, without a page refresh/reload confirming Turbo Streams is working.
  #
  # Similar process is done for the sender.

  describe "Dropdown Notifications" do
    context "when a user accepts a friend request" do
      it "sends a real-time notification to both users and prepends it to their dropdown notifications list" do
        create(:friend_request, sender: sender, receiver: receiver)

        using_session :receiver do 
          login_as(receiver)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :sender do
          login_as(sender)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :receiver do
          create(:friendship, user: receiver, friend: sender)
          find(:id, 'notificationsDropdown').click

          receiver_new_notifications_frame = find("turbo-frame#new_notifications_#{receiver.id}")
  
          expect(receiver_new_notifications_frame).to have_content("You and #{sender.username} are now friends")
          expect(page).to have_current_path(posts_path)
        end
        
        using_session :sender do
          find(:id, 'notificationsDropdown').click

          sender_new_notifications_frame = find("turbo-frame#new_notifications_#{sender.id}")

          expect(sender_new_notifications_frame).to have_content("You and #{receiver.username} are now friends")
          expect(page).to have_current_path(posts_path)
        end
      end
    end
  end  

  describe "New Notifications" do
    context "when a user accepts a friend request" do
      it "sends a real-time notification to both users and prepends it to their new_notifications frame under navbar" do
        create(:friend_request, sender: sender, receiver: receiver)

        using_session :receiver do 
          login_as(receiver)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :sender do
          login_as(sender)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :receiver do
          create(:friendship, user: receiver, friend: sender)
          notifications_frame = find("turbo-frame#notifications")
          within(notifications_frame) do
            receiver_new_notifications_frame = find("turbo-frame#new_notifications_#{receiver.id}")
            expect(receiver_new_notifications_frame).to have_content("You and #{sender.username} are now friends")
          end
        end
        
        using_session :sender do
          notifications_frame = find("turbo-frame#notifications")
          within(notifications_frame) do
            sender_new_notifications_frame = find("turbo-frame#new_notifications_#{sender.id}")
            expect(sender_new_notifications_frame).to have_content("You and #{receiver.username} are now friends")
          end
        end
      end
    end
  end  
end