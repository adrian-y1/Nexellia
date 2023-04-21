# This file contains system tests for liking posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/post_likes/like_post_spec.rb

require 'rails_helper'

RSpec.describe "Like Post", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index page" do
    # This test checks the functionality of liking posts on the posts#index page using Turbo Streams. 
    # It ensures that the user gets instant feedback upon liking a post, such as incrementing the 
    # likes counter and displaying the unlike button. 
    #
    # The test verifies the rendering of the like button and likes counter, and then clicks on 
    # the like button. 
    #
    # The subsequent expectation statements ensure that the user is still on the posts#index page, 
    # the 'Unlike' button has appeared, the Turbo Frame for likes has been rendered, and the likes counter has incremented. 
    # These checks confirm that Turbo Stream is working without the need for a page refresh.

    context "when liking a post on the index page" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Like')
        expect(page).to have_content('0 Likes')

        private_likes_frame = find("turbo-frame#post_#{post.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Like'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_button('Unlike')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes")
        expect(page).to have_content('1 Like')
      end
    end
  end

  describe "posts#show page" do
    # This test checks the functionality of liking posts on the posts#show page using Turbo Streams. 
    # It ensures that the user gets instant feedback upon liking a post, such as incrementing the 
    # likes counter and displaying the unlike button. 
    #
    # The test verifies the rendering of the like button and likes counter, and then clicks on 
    # the like button. 
    #
    # The subsequent expectation statements ensure that the user is still on the posts#show page, 
    # the 'Unlike' button has appeared, the Turbo Frame for likes has been rendered, and the likes counter has incremented. 
    # These checks confirm that Turbo Stream is working without the need for a page refresh.

    context "when liking a post on the show page" do
      it "increments the likes counter and displays unlike button live using Turbo Streams" do
        post = create(:post, user: user)
        visit post_path(post)

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

        expect(page).to have_button('Like')
        expect(page).to have_content('0 Likes')

        private_likes_frame = find("turbo-frame#post_#{post.id}\\ private_likes")
        within(private_likes_frame) do
          click_button 'Like'
        end
        
        expect(page).to have_current_path(post_path(post))
        expect(page).to have_button('Unlike')
        expect(page).to have_selector("turbo-frame#post_#{post.id}_likes")
        expect(page).to have_content('1 Like')
      end
    end
  end
end