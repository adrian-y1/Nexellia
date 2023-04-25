# This file contains system tests for real-time notifications for posting a new comment using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/new_comment_notification_spec.rb

require 'rails_helper'

RSpec.describe "New Comment Notification", type: :system, js: true do
  let(:author) { create(:user) }
  let(:commenter) { create(:user) }

  before do
    login_as(author)
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for sending a real-time notification to the post author 
  # when a user comments on their post. They also check if the notification is prepended to the correct 
  # element (the dropdown notifications list or the unread notification in the flash section)
  #
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a comment and Find the Turbo Frame tag for the respective Turbo Frame tag associated with the author.
  #
  # Lastly, the expectations for the notification and the current path, ensures
  # that the user is receiving the notification in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "Notifications Dropdown List" do
    context "when a user comments on a post" do
      it "sends a real-time notification to the post author and prepends it to their dropdown notifications list" do
        post = create(:post, user: author)
        visit posts_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        
        create(:comment, user: commenter, post: post)

        find(:id, 'notificationsDropdown').click

        all_notifications_frame = find("turbo-frame#all_notifications_#{author.id}")

        expect(all_notifications_frame).to have_content("#{commenter.username}\ncommented on your post")
        expect(page).to have_current_path(posts_path)
      end
    end
  end  

  describe "Unread Notification" do
    context "when a user comments on a post" do
      it "sends a real-time notification to the post author and displays it at the top of the page" do
        post = create(:post, user: author)
        visit user_path(author)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:comment, user: commenter, post: post)

        notifications_frame = find("turbo-frame#notifications")
        within(notifications_frame) do
          unread_notifications_frame = find("turbo-frame#unread_notifications_#{author.id}")
          expect(unread_notifications_frame).to have_content("#{commenter.username} commented on your post")
        end

        expect(page).to have_current_path(user_path(author))
      end
    end
  end  
end