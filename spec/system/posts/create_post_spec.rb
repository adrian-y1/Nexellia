# This file contains system tests for creating posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/create_post_spec.rb

require 'rails_helper'

RSpec.describe "Create Post", type: :system, js: true do
  let(:content) { 'My New Post!' }
  let(:flash_notice) { 'Post was successfully created.' }
  
  before do
    login_as(create(:user))
    driven_by(:selenium_chrome_headless)
  end

  describe "Valid Attributes" do
    # This test checks that a post can be successfully created using the create post form on the
    # index page of the application. Since the form is within a Turbo Frame tag, i
    # do not need to visit a separate page to access it.
    # 
    # I use Capybara to fill in the form and submit it. Since i'm using Turbo Streams
    # instead of a full page refresh, the post is created live and the user is not
    # redirected to a new page.
    # 
    # The test checks that the post is successfully created and that a flash notice is
    # displayed to the user. I also confirm that Turbo Streams is working by checking
    # that the post is created live without a page refresh.
    it "creates the post live with Turbo Streams" do
      visit posts_path
      new_post_frame = find("turbo-frame[id='new_post']")
      within(new_post_frame) do
        fill_in 'post[body]', with: content
        click_on 'Create Post'
      end

      # Confirms that the post was created live using Turbo Streams and that 
      # the user is still on the index page.
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content(content)
      expect(page).to have_content(flash_notice)
    end
  end

  describe "Invalid Attributes" do
    # This test checks that a post cannot be created with empty body field 
    # using the create post form on the index page of the application. 
    # Since the form is within a Turbo Frame tag, i do not need to visit a separate page to access it.
    # 
    # I use Capybara to fill in the form and submit it. Since i'm using Turbo Streams
    # instead of a full page refresh, the flash notice appears with no page reload.
    it "doesn't create the post and renders an error without page referesh" do
      visit posts_path
      new_post_frame = find("turbo-frame[id='new_post']")
      within(new_post_frame) do
        fill_in 'post[body]', with: ''
        click_on 'Create Post'
      end
      
      # Since the user hasn't been redirected after creating a post,
      # this confirms they are still on the index page and the flash notice
      # is displayed as a result of using Turbo Streams 
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("Body can't be blank")
    end
  end
end
