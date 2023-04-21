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

  describe "Valid Attributes" do
    # These tests check that a comment can be successfully created with valid attributes using 
    # the create comment form that is displayed inside a post. 
    #
    # With the help of Turbo Frames, i don't need to visit a seperate 
    # page to access the form.
    #
    # After the form is filled with data and submitted, the comment is created live and the user
    # is not redirect to a new page as a result of using Turbo Streams.
    #
    # The expect statements ensure that the comment is successfully created and that a flash notice 
    # is displayed to the user. They also confirm that Turbo Streams is working by checking the comment
    # is created and broadcasted live without a page refresh.

    describe "posts#index page" do
      # This test checks comment creation with valid attributes in the posts#index page using Turbo Streams.

      it "creates the comment with Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        post_frame = find("turbo-frame#post-interactions-#{post.id}")
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

    describe "posts#show page" do
      # This test checks comment creation with valid attributes in the posts#show page using Turbo Streams.

      it "creates the comment with Turbo Streams" do
        post = create(:post, user: user)
        visit post_path(post)

        post_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
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

    describe "users#show page" do
      # This test checks comment creation with valid attributes in the users#show page using Turbo Streams.

      it "creates the comment with Turbo Streams" do
        post = create(:post, user: user)
        visit user_path(post.user)

        post_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: content
          click_on 'Create Comment'
        end

        # Confirms that the comment was created live using Turbo Streams and that 
        # the user is still on the users#show page.
        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content(content)
        expect(page).to have_content(flash_notice)
      end
    end
  end

  describe "Invalid Attributes" do
    # These tests check that a comment cannot be created with an empty body
    #
    # With the help of Turbo Frames, i don't need to visit a seperate page to access the create comment form.
    #
    # After the form is filled with invalid data and submitted, the error message is displayed to the user
    # without a page refresh as a result of using Turbo Streams and Turbo Frames.
    #
    # The expect statements ensure that the comment was not created and that a flash notice is
    # displayed to the user. They also confirm that Turbo Streams is working by checking
    # that the comment is not created live without a page refresh.

    describe "posts#index page" do
      it "doesn't create the comment and renders an error with Turbo Streams" do
        post = create(:post, user: user)
        visit posts_path

        post_frame = find("turbo-frame#post-interactions-#{post.id}")
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

    describe "posts#show page" do
      it "doesn't create the comment and renders an error with Turbo Streams" do
        post = create(:post, user: user)
        visit post_path(post)

        post_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
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

    describe "users#show page" do
      it "doesn't create the comment and renders an error with Turbo Streams" do
        post = create(:post, user: user)
        visit user_path(post.user)

        post_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_frame) do
          fill_in 'comment[body]', with: ''
          click_on 'Create Comment'
        end

        # Since the user hasn't been redirected after encountering an error with creating a comment,
        # this confirms Turbo Streams is working and that they are on the posts#show page.
        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content("Body can't be blank")
      end
    end
  end
end