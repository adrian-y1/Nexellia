# This file contains system tests for unliking posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/post_likes/unlike_post_spec.rb

require 'rails_helper'

RSpec.describe 'Unlike Post', type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index page" do
    # This test checks unliking posts on the posts#index page using Turbo Streams.
    # With the use of Turbo Streams, the user is able to get instant feedback upon unliking a post.
    # This includes decrementing the likes counter and displaying the like button instead.
    #
    # The first couple expectation statements are used to make sure that the 
    # unlike button has been rendered into the page as well as the likes counter.
    #
    # After that, the test clicks on "Unlike" button after finding it's Turbo Frame.
    # 
    # The expectation statements following it ensures that the user is still on the posts#index page,
    # the 'Like' button has appeared, the Turbo Frame for likes has been rendered,
    # and the likes counter has decremented. 
    # These all ensure that Turbo Stream is working because there hasn't been a page refresh.

    context "when unliking a post on the posts#index page" do
      it "decrements the likes counter and displays like button live using Turbo Streams" do
        post = create(:post, user: user)
        user.like(post)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Unlike')
        expect(page).to have_content('1 Like')

        private_likes_frame = find("turbo-frame#post_#{post.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Unlike'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Like')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes")
        expect(page).to have_content('0 Likes')
      end
    end
  end

  describe "posts#show page" do
    # This test checks the functionality of unliking posts on the posts#show page using Turbo Streams. 
    # It ensures that the user gets instant feedback upon unliking a post, such as decrementing the 
    # likes counter and displaying the like button. 
    #
    # The test verifies the rendering of the unlike button and likes counter, and then clicks on 
    # the unlike button. 
    #
    # The subsequent expectation statements ensure that the user is still on the posts#show page, 
    # the 'Like' button has appeared, the Turbo Frame for likes has been rendered, and the likes counter has decremented. 
    # These checks confirm that Turbo Stream is working without the need for a page refresh.

    context "when unliking a post on the posts#show page" do
      it "decrements the likes counter and displays like button live using Turbo Streams" do
        post = create(:post, user: user)
        user.like(post)
        visit post_path(post)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Unlike')
        expect(page).to have_content('1 Like')

        private_likes_frame = find("turbo-frame#post_#{post.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Unlike'
        end

        expect(page).to have_current_path(post_path(post))
        expect(page).to have_button('Like')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes")
        expect(page).to have_content('0 Likes')
      end
    end
  end
end