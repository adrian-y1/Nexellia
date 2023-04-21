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
      post_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
      within(post_frame) do
        click_on "Delete"
      end

      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content(flash_notice)
    end
  end

  describe "posts#show Page" do
    # This test checks that a post can be successfully deleted inside the posts#show page.
    #
    # With the use of a stimulus controller, i created a functionality that redirects
    # every user that was/is on the show page of the deleted post after 5 seconds.
    # This is done through broadcasting to the "post_deleted" stream that renders the 
    # _post_deleted.html.erb partial.
    # 
    # With these functionalities in place, the test is able to check that, when a post is deleted,
    # the flash notice is displayed without a page refresh, and after 5 seconds, all users 
    # who are on the show page of the deleted post, will get redirected to the index page.

    before do
      post = create(:post, user: user)
    end

    it "deletes the post, renders flash notice and redirects all subscribed users to index page after 5 seconds using Turbo Streams" do
      post = user.posts.last

      visit post_path(post)
      post_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
      within(post_frame) do
        click_on "Delete"
      end

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content(flash_notice)
      expect(page).to have_content('Redirecting to the feed page in')
      sleep(5)
      expect(page).to have_current_path(posts_path)
    end
  end
end