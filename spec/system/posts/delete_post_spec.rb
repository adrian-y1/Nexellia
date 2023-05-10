# This file contains system tests for deleting posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/delete_post_spec.rb

require 'rails_helper'

RSpec.describe "Delete Post", type: :system, js: true do
  # The following tests test the delete post functionality with Turbo Streams inside the index page.

  let(:user) { create(:user) }
  let(:flash_notice) { "Post was successfully deleted."}

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # These test check that a post can be successfully deleted using Turbo Streams.
  # Since the post is within a Turbo Frame tag, i do not need to visit a seperate 
  # page to access it.
  #
  # Since i'm using Turbo Streams, instead of a full page refresh, 
  # the post is deleted live and the user is not redirected to a new page.
  #
  # With this functionality in place, the tests are able to check that, when a post is deleted,
  # the flash notice is displayed without a page refresh.

  describe "posts#index Page" do
    # This test checks that a post can be successfully deleted in the posts#index page
    # using Turbo Streams.

    before do
      post = create(:post, user: user)
    end

    it "deletes the post and renders flash notice using Turbo Streams" do
      visit posts_path

      expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

      post_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
      within(post_frame) do
        click_on "Delete"
      end

      expect(page).to have_current_path(posts_path)
      expect(page).to have_content(flash_notice)
    end
  end

  describe "users#show Page" do
    # This test checks that a post can be successfully deleted in the users#show page
    # using Turbo Streams.

    before do
      post = create(:post, user: user)
    end

    it "deletes the post and renders flash notice using Turbo Streams" do
      visit user_path(user)

      expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

      post_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
      within(post_frame) do
        click_on "Delete"
      end

      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content(flash_notice)
    end
  end

  describe "posts#show Page" do
    # This test checks that a post can be successfully deleted inside the posts#show page/modal and
    # displays a message in the modal to every user that had the modal opened.
    #
    # When a post is deleted, the flash notice is displayed without a page refresh, all users 
    # who are on the show page/modal of the deleted post, will get a message about the deleted post they are viewing.

    before do
      post = create(:post, user: user)
    end

    it "deletes the post, renders flash notice and redirects all subscribed users to index page after 5 seconds using Turbo Streams" do
      post = user.posts.last
      visit post_path(post)

      expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

      post_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
      within(post_frame) do
        click_on "Delete"
      end

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content(flash_notice)
      expect(page).to have_content('The post you were viewing has been deleted and no longer exists')
    end
  end
end