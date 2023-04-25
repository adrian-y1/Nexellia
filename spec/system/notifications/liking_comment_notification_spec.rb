# This file contains system tests for real-time notifications for liking comments using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/liking_comment_notification_spec.rb

require 'rails_helper'

RSpec.describe "Liking Comment Notification", type: :system, js: true do
  let(:creator) { create(:user) }
  let(:liker) { create(:user) }

  before do
    login_as(creator)
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for sending a real-time notification to the
  # comment creator when a user likes their comment. They also check if the notification is prepended to the correct 
  # element (the dropdown notifications list or the unread notification in the flash section)
  #
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a CommentLike object and find the Turbo Frame tag associated with the creator.
  #
  # Lastly, the expectations for the notification and the current path, ensures
  # that the user is receiving the notification in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "Notifications Dropdown List" do
    context "when a user likes a comment" do
      it "sends a real-time notification to the comment creator and prepends it to their dropdown notifications list" do
        post = create(:post)
        comment = create(:comment, user: creator, post: post)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:comment_like, liked_comment: comment, liker: liker)

        find(:id, 'notificationsDropdown').click

        all_notifications_frame = find("turbo-frame#all_notifications_#{creator.id}")

        expect(all_notifications_frame).to have_content("#{liker.username}\nliked your comment")
        expect(page).to have_current_path(posts_path)
      end
    end
  end  

  describe "Unread Notification" do
    context "when a user likes a comment" do
      it "sends a real-time notification to the comment creator and displays it at the top of the page" do
        post = create(:post)
        comment = create(:comment, user: creator, post: post)
        visit user_path(creator)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        create(:comment_like, liked_comment: comment, liker: liker)

        notifications_frame = find("turbo-frame#notifications")
        within(notifications_frame) do
          unread_notifications_frame = find("turbo-frame#unread_notifications_#{creator.id}")
          expect(unread_notifications_frame).to have_content("#{liker.username} liked your comment")
        end

        expect(page).to have_current_path(user_path(creator))
      end
    end
  end  
end