# This file contains system tests for real-time notifications count using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/notifications/notifications_count_spec.rb

require 'rails_helper'

RSpec.describe "Notifications Count", type: :system, js: true do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }

  before do
    login_as(recipient)
    driven_by(:selenium_chrome_headless)
  end

  # These tests are for updating the unread and read notifications counter for the recipient in real-time using Turbo Streams
  #
  # ----- UNREAD -----
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a database record for the respective notification type for the test examples.
  #
  # Lastly, the expectations for the notification count incrementing and the current path, ensures that the recipient is 
  # receiving the updated notifications count in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.
  #
  # ----- READ -----
  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  # Then, create a database record for the respective notification type for the test examples.
  #
  # Then, find the notification url for the respective notification type and open the notifications dropdown.
  # Find the user's dropdown_notifications Turbo Frame and click on the notification link found earlier.
  #
  # Lastly, the expectations for the notification count decrementing and the current path, ensures that the recipient is 
  # receiving the updated notifications count in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "Friend Request Notification" do
    context "when the recipient receives a notification" do
      it "increments the recipient's unread notifications count in real-time" do
        visit posts_path
  
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
        expect(notifications_count_frame).to have_content('0')
  
        create(:friend_request, sender: user, receiver: recipient)
  
        expect(notifications_count_frame).to have_content('1')
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when the recipient reads a notification by clicking on it" do
      it "decrements the recipient's unread notifications count in real-time" do
        visit posts_path
  
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
        
        create(:friend_request, sender: user, receiver: recipient)
        expect(notifications_count_frame).to have_content('1')

        sender_notification_url = "/users/#{user.id}?notification_id=#{recipient.notifications.last.id}"

        find_button(class: 'navbar__notifications-dropdown--toggle').click
        dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{recipient.id}")
        within dropdown_notifications_frame do
          link = find("a[href=\"#{sender_notification_url}\"]")
          page.execute_script("arguments[0].click();", link)
        end

        expect(notifications_count_frame).to have_content('0')
        expect(page).to have_current_path(sender_notification_url)
      end
    end
  end

  describe "New Comment Notification" do
    context "when the recipient receives a notification" do
      it "increments the recipient's unread notifications count in real-time" do
        post = create(:post, user: recipient)
        visit posts_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        
        notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
        expect(notifications_count_frame).to have_content('0')
  
        create(:comment, user: user, commentable: post)
        
        expect(notifications_count_frame).to have_content('1')
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when the recipient reads a notification by clicking on it" do
      it "decrements the recipient's unread notifications count in real-time" do
        post = create(:post, user: recipient)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
        
        create(:comment, user: user, commentable: post)
        expect(notifications_count_frame).to have_content('1')

        post_notification_url = "/posts/#{post.id}?notification_id=#{recipient.notifications.last.id}"

        find_button(class: 'navbar__notifications-dropdown--toggle').click
        dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{recipient.id}")
        within dropdown_notifications_frame do
          link = find("a[href=\"#{post_notification_url}\"]")
          page.execute_script("arguments[0].click();", link)
        end

        expect(notifications_count_frame).to have_content('0')
        expect(page).to have_current_path(post_notification_url)
      end
    end
  end

  describe "Like Notification" do
    describe "Post" do
      context "when the recipient receives a notification" do
        it "increments the recipient's unread notifications count in real-time" do
          post = create(:post, user: recipient)
          visit user_path(recipient)
  
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
          
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
          expect(notifications_count_frame).to have_content('0')
          
          create(:like, likeable: recipient.posts.last, user: user)
          
          expect(notifications_count_frame).to have_content('1')
          expect(page).to have_current_path(user_path(recipient))
        end
      end

      context "when the recipient reads a notification by clicking on it" do
        it "decrements the recipient's unread notifications count in real-time" do
          post = create(:post, user: recipient)
          visit user_path(recipient)
  
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
    
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
          
          create(:like, likeable: recipient.posts.last, user: user)
          expect(notifications_count_frame).to have_content('1')
  
          post_notification_url = "/posts/#{post.id}?notification_id=#{recipient.notifications.last.id}"
  
          find_button(class: 'navbar__notifications-dropdown--toggle').click
          dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{recipient.id}")
          within dropdown_notifications_frame do
            link = find("a[href=\"#{post_notification_url}\"]")
            page.execute_script("arguments[0].click();", link)
          end
  
          expect(notifications_count_frame).to have_content('0')
          expect(page).to have_current_path(post_notification_url)
        end
      end
    end

    describe "Comment" do
      context "when the recipient receives a notification" do
        it "increments the recipient's unread notifications count in real-time" do
          post = create(:post)
          comment = create(:comment, user: recipient, commentable: post)
          visit user_path(recipient)
  
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
          expect(notifications_count_frame).to have_content('0')
          
          create(:like, likeable: recipient.comments.last, user: user)
          
          expect(notifications_count_frame).to have_content('1')
          expect(page).to have_current_path(user_path(recipient))
        end
      end

      context "when the recipient reads a notification by clicking on it" do
        it "decrements the recipient's unread notifications count in real-time" do
          post = create(:post)
          comment = create(:comment, user: recipient, commentable: post)
          visit user_path(recipient)
  
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
    
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
          
          create(:like, likeable: recipient.comments.last, user: user)
          expect(notifications_count_frame).to have_content('1')
  
          post_notification_url = "/posts/#{post.id}?notification_id=#{recipient.notifications.last.id}"
  
          find_button(class: 'navbar__notifications-dropdown--toggle').click
          dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{recipient.id}")
          within dropdown_notifications_frame do
            link = find("a[href=\"#{post_notification_url}\"]")
            page.execute_script("arguments[0].click();", link)
          end
  
          expect(notifications_count_frame).to have_content('0')
          expect(page).to have_current_path(post_notification_url)
        end
      end
    end
  end

  describe "Accepting Friend Request Notification" do
    context "when both users receive a notification" do
      it "increments the both the recipient's and the user's unread notifications count in real-time" do
        create(:friend_request, sender: user, receiver: recipient)
  
        using_session :recipient do 
          login_as(recipient)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :user do
          login_as(user)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :recipient do
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")
          expect(notifications_count_frame).to have_content('1')
          
          create(:friendship, user: recipient, friend: user)
          
          expect(notifications_count_frame).to have_content('2')
          expect(page).to have_current_path(posts_path)
        end
        
        using_session :user do
          notifications_count_frame = find("turbo-frame#user_#{user.id}_notifications_count")
          
          expect(notifications_count_frame).to have_content('1')
          expect(page).to have_current_path(posts_path)
        end
      end
    end

    context "when the recipient reads a notification by clicking on it" do
      it "decrements the recipient's unread notifications count in real-time" do
        create(:friend_request, sender: user, receiver: recipient)
  
        using_session :recipient do 
          login_as(recipient)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :user do
          login_as(user)
          visit posts_path
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        end
        
        using_session :recipient do
          find_button(class: 'navbar__notifications-dropdown--toggle').click
          notifications_count_frame = find("turbo-frame#user_#{recipient.id}_notifications_count")

          expect(notifications_count_frame).to have_content('1')
          create(:friendship, user: recipient, friend: user)
          expect(notifications_count_frame).to have_content('2')

          friend_notifications_url = "/users/#{user.id}?notification_id=#{recipient.notifications.last.id}"
          dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{recipient.id}")
          within dropdown_notifications_frame do
            link = find("a[href=\"#{friend_notifications_url}\"]")
            page.execute_script("arguments[0].click();", link)
          end

          expect(notifications_count_frame).to have_content('1')
          expect(page).to have_current_path(friend_notifications_url)
        end
        
        using_session :user do
          find_button(class: 'navbar__notifications-dropdown--toggle').click
          notifications_count_frame = find("turbo-frame#user_#{user.id}_notifications_count")

          expect(notifications_count_frame).to have_content('1')

          friend_notifications_url = "/users/#{recipient.id}?notification_id=#{user.notifications.last.id}"
          dropdown_notifications_frame = find("turbo-frame#dropdown_notifications_#{user.id}")
          within dropdown_notifications_frame do
            link = find("a[href=\"#{friend_notifications_url}\"]")
            page.execute_script("arguments[0].click();", link)
          end

          expect(notifications_count_frame).to have_content('0')
          expect(page).to have_current_path(friend_notifications_url)
        end
      end
    end
  end
end