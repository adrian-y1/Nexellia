# This file contains system tests for real-time notifications for liking comments and posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/liking_notification_spec.rb

require 'rails_helper'

RSpec.describe "Liking Notification", type: :system, js: true do
  let(:author) { create(:user) }
  let(:liker) { create(:user) }

  before do
    login_as(author)
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for sending a real-time notification to the likeable (post or comment) author 
  # when a user likes their likeable. They also check if the notification is prepended to the correct 
  # element (the dropdown notifications list or the new notifications in the flash section)
  #
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a like object with the respective likeable object and find the Turbo Frame tag associated with the author.
  #
  # Lastly, the expectations for the notification and the current path, ensures
  # that the user is receiving the notification in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "Dropdown Notifications" do
    context "when a user likes a comment" do
      it "sends a real-time notification to the comment author and prepends it to their dropdown notifications list" do
        post = create(:post)
        comment = create(:comment, user: author, post: post)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:like, likeable: comment, user: liker)

        find(:id, 'notificationsDropdown').click

        dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{author.id}")

        expect(dropdown_notifications_frame).to have_content("#{liker.username} liked your comment")
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when a user likes a post" do
      it "sends a real-time notification to the post author and prepends it to their dropdown notifications list" do
        post = create(:post, user: author)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:like, likeable: post, user: liker)

        find(:id, 'notificationsDropdown').click

        dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{author.id}")

        expect(dropdown_notifications_frame).to have_content("#{liker.username} liked your post")
        expect(page).to have_current_path(posts_path)
      end
    end
  end  

  describe "New Notifications" do
    context "when a user likes a comment" do
      it "sends a real-time notification to the comment author and prepends it to their new_notifications frame under navbar" do
        post = create(:post)
        comment = create(:comment, user: author, post: post)
        visit user_path(author)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:like, likeable: comment, user: liker)

        notifications_frame = find("turbo-frame#notifications")
        within(notifications_frame) do
          new_notifications_frame = find("turbo-frame#new_notifications_#{author.id}")
          expect(new_notifications_frame).to have_content("#{liker.username} liked your comment")
        end

        expect(page).to have_current_path(user_path(author))
      end
    end

    context "when a user likes a post" do
      it "sends a real-time notification to the post author and prepends it to their new_notifications frame under navbar" do
        post = create(:post, user: author)
        visit user_path(author)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:like, likeable: post, user: liker)

        notifications_frame = find("turbo-frame#notifications")
        within(notifications_frame) do
          new_notifications_frame = find("turbo-frame#new_notifications_#{author.id}")
          expect(new_notifications_frame).to have_content("#{liker.username} liked your post")
        end

        expect(page).to have_current_path(user_path(author))
      end
    end
  end  
end