# This file contains system tests for liking comments using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/likes/like_comment_spec.rb

require 'rails_helper'

RSpec.describe "Like Comment", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  #
  # Then, open the post, create and like the comment by clicking the 'Like' button after finding the Turbo Frame 
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the 'Unlike' button, '1 Like' (counter incremented) and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "posts#show Modal" do
    # This test checks the functionality for liking a comment on the posts#show modal using Turbo Streams. 

    context "when liking a comment on the posts#show modal" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        
        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        post_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: 'sadasdasd'
          find_button(class: "modal__footer__comments-form--button").click
        end
        
        expect(page).to have_button('Like')
        comment_likes_frame = find("turbo-frame#comment_#{user.comments.last.id}_likes")
        expect(comment_likes_frame).to have_content('0')
        
        
        private_likes_frame = find("turbo-frame#comment_#{user.comments.last.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Like'
        end
        
        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Unlike')
        expect(page).to have_selector("turbo-frame#comment_#{user.comments.last.id}_likes", wait: 10)
        expect(comment_likes_frame).to have_content('1')
      end
    end
  end
end