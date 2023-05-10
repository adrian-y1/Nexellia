# This file contains system tests for liking posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/likes/like_post_spec.rb

require 'rails_helper'

RSpec.describe "Like Post", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  #
  # Then, like the post by clicking the 'Like' button after finding the Turbo Frame 
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the 'Unlike' button, '1 Like' (counter incremented) and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.

  describe "posts#index page" do
    # This test checks the functionality of liking posts on the posts#index page using Turbo Streams. 

    context "when liking a post on the posts#index page" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Like')
        expect(page).to have_content('0 Likes')

        private_likes_index_frame = find("turbo-frame#post_#{post.id}\\ private_likes_index")
        within(private_likes_index_frame) do
          click_button 'Like'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Unlike')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes_index")
        expect(page).to have_content('1 Like')
      end
    end
  end

  describe "posts#show Modal" do
    # This test checks the functionality of liking posts on the posts#show page using Turbo Streams. 

    context "when liking a post on the posts#show page" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        expect(page).to have_button('Like')
        expect(page).to have_content('0 Likes')

        private_likes_show_frame = find("turbo-frame#post_#{post.id}\\ private_likes_show")
        within(private_likes_show_frame) do
          click_button 'Like'
        end
        
        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Unlike')
        
        public_likes_show_frame = find("turbo-frame#post_#{post.id}_likes_show")
        expect(public_likes_show_frame).to have_content('1 Like')
      end
    end
  end

  describe "users#show page" do
    # This test checks the functionality of liking posts on the users#show page using Turbo Streams. 

    context "when liking a post on the users#show page" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit user_path(post.user)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Like')
        expect(page).to have_content('0 Likes')

        private_likes_index_frame = find("turbo-frame#post_#{post.id}\\ private_likes_index")
        within(private_likes_index_frame) do
          click_button 'Like'
        end
        
        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_button('Unlike')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes_index")
        expect(page).to have_content('1 Like')
      end
    end
  end
end