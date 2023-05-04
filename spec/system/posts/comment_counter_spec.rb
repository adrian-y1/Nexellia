# This file contains system tests for a post's comments counter using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/comment_counter_spec.rb

require 'rails_helper'

RSpec.describe "Post Comments Counter", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index Page" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # inside the posts#index page using Turbo Streams.

    before do 
      create(:post, user: user)
      visit posts_path
    end
    
    context "when a comment is created" do
      # Once a comment is created by accessing the appropriate Turbo Frame tag, which
      # will not require a page refresh, the comments counter for the specified post
      # incremenets in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          click_on 'Create Comment'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comment is deleted" do
      # After a comment is created by accessing the appropriate Turbo Frame tag, which
      # does not require a page refresh, the comments counter for the specified post
      # decrements in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          fill_in 'comment[body]', with: 'Comment 1'
          click_on 'Create Comment'
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          click_on "Delete"
        end

        # This confirms that we are still on the current page with no 
        # page refresh/redirect, and the counter has been decremented after a post is deleted, 
        # meaning Turbo Streams is working.
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('0 Comments')
      end
    end
  end

  describe "posts#show Page" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # inside the posts#show page using Turbo Streams.

    before do 
      create(:post, user: user)
    end
    
    context "when a comment is created" do
      # Once the comments are created by accessing the appropriate Turbo Frame tags, which
      # do not require a page refresh, the comments counter for the specified post
      # incremenets in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        visit post_path(post)

        expect(page).to have_content('0 Comments')

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          click_on 'Create Comment'
        end

        expect(page).to have_current_path(post_path(post))
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comment is deleted" do
      # After a comment is created by accessing the appropriate Turbo Frame tag, which
      # does not require a page refresh, the comments counter for the specified post
      # decrements in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit post_path(post)

        expect(page).to have_content('0 Comments')

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Comment 1'
          click_on 'Create Comment'
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          click_on "Delete"
        end

        # This confirms that we are still on the current page with no 
        # page refresh/redirect, and the counter has been decremented after a comment was deleted, 
        # meaning Turbo Streams is working.
        expect(page).to have_current_path(post_path(post))
        expect(page).to have_content('0 Comments')
      end
    end
  end

  describe "users#show Page" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # inside the users#show page using Turbo Streams.

    before do 
      create(:post, user: user)
    end
    
    context "when a comment is created" do
      # Once the comments are created by accessing the appropriate Turbo Frame tags, which
      # do not require a page refresh, the comments counter for the specified post
      # incremenets in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        visit user_path(post.user)

        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          click_on 'Create Comment'
        end

        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comment is deleted" do
      # After a comment is created by accessing the appropriate Turbo Frame tag, which
      # does not require a page refresh, the comments counter for the specified post
      # decrements in real-time without a redirect or refresh of the current page. 
      # This confirms that Turbo Streams is working.

      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit user_path(post.user)

        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          fill_in 'comment[body]', with: 'Comment 1'
          click_on 'Create Comment'
        end

        # Expects the comments counter to have incremented after a comment was deleted
        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          click_on "Delete"
        end
        
        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content('0 Comments')
      end
    end
  end
end
