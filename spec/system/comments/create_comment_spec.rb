# This file contains system tests for creating comments using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/comments/create_comment_spec.rb

require 'rails_helper'

RSpec.describe "Create Comment", type: :system, js: true do
  let(:user) { create(:user) }
  let(:content) { "I just commented!" }
  let(:flash_notice) { 'Comment was successfully created.' }
  
  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index Page" do
    # These tests check comment creation inside the posts#index page with valid and 
    # invalid attributes. And they also test to see if Turbo Streams is working.

    describe "Valid Attributes" do
      # This test checks that a comment can be successfully created using the create comment form
      # that is displayed inside a post. With the help of Turbo Frames, i don't need to visit a seperate
      # page to access the form as it can be done so in the posts#index page where the posts are listed.
      #
      # After the form is filled and submitted, the comment is created live and the user 
      # is not redirected to a new page as a result of using Turbo Streams.
      # 
      # The expect statements ensure that the comment is successfully created and that a flash notice is
      # displayed to the user. They also confirm that Turbo Streams is working by checking
      # that the comment is created live without a page refresh.

      it "creates the comment with Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        post_frame = find("turbo-frame#post_#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: content
          click_on 'Create Comment'
        end

        # Confirms that the comment was created live using Turbo Streams and that 
        # the user is still on the posts#index page.
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content(content)
        expect(page).to have_content(flash_notice)
      end
    end

    describe "Invalid Attributes" do
      # Similar to the 'Valid Attributes' test, however this test covers the the case when
      # user attempts to submit an empty body. Again, with the help of Turbo Frames, i don't need to visit a seperate
      # page to access the form as it can be done so in the posts#index page where the posts are listed.
      #
      # After the form is submitted with empty body, the flash notice is displayed to the user
      # with no page refresh/reload.
      # 
      # The expect statements ensure that the comment was not created and that a flash notice is
      # displayed to the user. They also confirm that Turbo Streams is working by checking
      # that the comment is created live without a page refresh.

      it "doesn't create the comment and renders an error with Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        post_frame = find("turbo-frame#post_#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: ''
          click_on 'Create Comment'
        end

        # Since the user hasn't been redirected after encountering an error with creating a comment,
        # this confirms Turbo Streams is working and that they are on the posts#index page.
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe "posts#show Page" do
    # These tests check comment creation inside the posts#show page with valid and 
    # invalid attributes. And they also test to see if Turbo Streams is working.

    describe "Valid Attributes" do
      # This test checks that a comment can be successfully created using the create comment form
      # that is displayed inside a post on the posts#show page. With the help of Turbo Frames, i don't need to visit a seperate
      # page to access the form as it can be done so on the show page of the desired post.
      #
      # After the form is filled and submitted, the comment is created live and the user 
      # is not redirected to a new page as a result of using Turbo Streams.
      # 
      # The expect statements ensure that the comment is successfully created and that a flash notice is
      # displayed to the user. They also confirm that Turbo Streams is working by checking
      # that the comment is created live without a page refresh.

      it "creates the comment with Turbo Streams" do
        post = create(:post, user: user)
        visit post_path(post)

        post_frame = find("turbo-frame#post_#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: content
          click_on 'Create Comment'
        end

        # Confirms that the comment was created live using Turbo Streams and that 
        # the user is still on the posts#show page.
        expect(page).to have_current_path(post_path(post))
        expect(page).to have_content(content)
        expect(page).to have_content(flash_notice)
      end
    end

    describe "Invalid Attributes" do
      # Similar to the 'Valid Attributes' test, however this test covers the the case when
      # user attempts to submit an empty body. Again, with the help of Turbo Frames, i don't need to visit a seperate
      # page to access the form as it can be done so on the show page of the post.
      #
      # After the form is submitted with empty body, the flash notice is displayed to the user
      # with no page refresh/reload.
      # 
      # The expect statements ensure that the comment was not created and that a flash notice is
      # displayed to the user. They also confirm that Turbo Streams is working by checking
      # that the comment is created live without a page refresh.

      it "doesn't create the comment and renders an error with Turbo Streams" do
        post = create(:post, user: user)
        visit post_path(post)

        post_frame = find("turbo-frame#post_#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: ''
          click_on 'Create Comment'
        end

        # Since the user hasn't been redirected after encountering an error with creating a comment,
        # this confirms Turbo Streams is working and that they are on the posts#show page.
        expect(page).to have_current_path(post_path(post))
        expect(page).to have_content("Body can't be blank")
      end
    end
  end
end