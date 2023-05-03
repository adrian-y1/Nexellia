# This file contains system tests for unliking comments using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/likes/unlike_comment_spec.rb

require 'rails_helper'

RSpec.describe 'Unlike Comment', type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  #
  # Then, unlike the comment by clicking the 'Unlike' button after finding the Turbo Frame 
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the 'Like' button, '0 Likes' (counter decremented) and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "posts#index page" do
    # This test checks unliking comments on the posts#index page using Turbo Streams.

    context "when unliking a comment on the posts#index page" do
      it "decrements the likes counter and displays like button live using Turbo Streams" do
        post = create(:post, user: user)
        comment = create(:comment, commentable: post, user: user)
        user.like(comment)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Unlike')
        expect(page).to have_content('1 Like')

        private_likes_frame = find("turbo-frame#comment_#{comment.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Unlike'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Like')
        expect(page).to have_selector("turbo-frame#comment_#{comment.id}_likes")
        expect(page).to have_content('0 Likes')
      end
    end
  end

  describe "posts#show page" do
    # This test checks the functionality of unliking comments on the posts#show page using Turbo Streams. 

    context "when unliking a comment on the posts#show page" do
      it "decrements the likes counter and displays like button live using Turbo Streams" do
        post = create(:post, user: user)
        comment = create(:comment, commentable: post, user: user)
        user.like(comment)
        visit post_path(post)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Unlike')
        expect(page).to have_content('1 Like')

        private_likes_frame = find("turbo-frame#comment_#{comment.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Unlike'
        end

        expect(page).to have_current_path(post_path(post))
        expect(page).to have_button('Like')
        expect(page).to have_selector("turbo-frame#comment_#{comment.id}_likes")
        expect(page).to have_content('0 Likes')
      end
    end
  end

  describe "users#show page" do
    # This test checks the functionality of unliking comments on the users#show page using Turbo Streams. 

    context "when unliking a comment on the users#show page" do
      it "decrements the likes counter and displays like button live using Turbo Streams" do
        post = create(:post, user: user)
        comment = create(:comment, commentable: post, user: user)
        user.like(comment)
        visit user_path(post.user)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Unlike')
        expect(page).to have_content('1 Like')

        private_likes_frame = find("turbo-frame#comment_#{comment.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Unlike'
        end

        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_button('Like')
        expect(page).to have_selector("turbo-frame#comment_#{comment.id}_likes")
        expect(page).to have_content('0 Likes')
      end
    end
  end
end