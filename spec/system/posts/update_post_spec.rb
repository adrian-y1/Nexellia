# This file contains system tests for updating posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/update_post_spec.rb

require 'rails_helper'

RSpec.describe "Update Post", type: :system, js: true do
  let(:user) { create(:user) }
  let(:uri_error) { URI::InvalidURIError }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "Index Page" do
    # The following tests test the update post functionality with Turbo Streams inside the index page.
    # They test valid & invalid attributes to cover all bases with updating posts.
    
    before do
      post = create(:post, user: user)
      visit posts_path
    end

    describe "Valid Attributes" do
      # This test checks that a post can be successfully updated using the edit form of a post.
      # This is done by clicking the 'Edit' button on the desired post, inside the index page.
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate 
      # page to access it.
      #
      # Since i'm using Turbo Streams, instead of a full page refresh, 
      # the post is created live and the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.
      
      context "when updating a post" do
        it "updates the post using Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'
 
          edit_post_frame = find("turbo-frame#post_#{user.posts.last.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: updated_content
            click_on "Update Post"
          end
          
          # Since the user hasn't been redirected after updating the post and is still on the index page, 
          # this confirms that Turbo Streams is working as the updated post is streamed live.
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end
    end
  
    describe "Invalid Attributes" do
      # These tests follow similar steps to the 'Valid Attributes' tests, however
      # they test invalid attributes with updating a post.
      #
      # Since i'm using Turbo Streams instead of a full page refresh, 
      # the flash notice appears with no page reload.
      
      context "when updating a post with empty body" do
        it "Fails to update the post with empty content and shows error message using Turbo Streams" do
          edit_post_frame = find("turbo-frame#post_#{user.posts.last.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: ''
            click_button 'Update Post'
          end
          
          # Since the user hasn't been redirected after encountering an error with updating, 
          # this confirms that they are still on the index page and Turbo Streams is working.
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('form')
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and shows error message using Turbo Streams" do
          updated_content = Faker::Lorem.characters(number: 300)
          edit_post_frame = find("turbo-frame#post_#{user.posts.last.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: updated_content
            click_button 'Update Post'
          end

          # Since the user hasn't been redirected after encountering an error with updating, 
          # this confirms that they are still on the index page and Turbo Streams is working.
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content("Body Post description length exceeded")
          expect(page).to have_selector('form')
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders index page using Turbo Streams" do
          edit_post_frame = find("turbo-frame#post_#{user.posts.last.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            click_on 'Cancel'
          end

          cancel_btn = find_link('Cancel')
          expect(page).to_not have_content(cancel_btn)
          expect(page).to have_current_path(posts_path)
        end
      end
    end
  end

  describe "Show Page" do
    # The following tests test the update post functionality with Turbo Streams inside the show page.
    # They test valid & invalid attributes to cover all bases with updating posts.

    let(:post) { create(:post, user: user) }

    before do
      visit post_path(post)
    end

    describe "Valid Attributes" do
      # This test checks that a post can be successfully updated using the edit form of a post.
      # This is done by clicking the 'Edit' button on the desired post, inside the show page.
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate 
      # page to access it.
      #
      # Since i'm using Turbo Streams, instead of a full page refresh, 
      # the post is created live and the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.

      context "when updating a post" do
        it "updates the post with Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          edit_post_frame = find("turbo-frame#post_#{post.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: updated_content
            click_on "Update Post"
          end

          # Since the user hasn't been redirected after updating the post and is still on the show page, 
          # this confirms that Turbo Streams is working as the updated post is streamed live.
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end
    end
  
    describe "Invalid Attributes" do
      # These tests follow similar steps to the 'Valid Attributes' tests, however
      # they test invalid attributes with updating a post.
      #
      # Since i'm using Turbo Streams instead of a full page refresh, 
      # the flash notice appears with no page reload.

      context "when updating a post with empty body" do
        it "Fails to update the post with empty content and shows error message using Turbo Streams" do
          edit_post_frame = find("turbo-frame#post_#{post.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: ''
            click_on "Update Post"
          end
          
          # Since the user hasn't been redirected after encountering an error with updating, 
          # this confirms that they are still on the show page and Turbo Streams is working.
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('form')
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and shows error message using Turbo Streams" do
          updated_content = Faker::Lorem.characters(number: 300)
          edit_post_frame = find("turbo-frame#post_#{post.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            fill_in 'post[body]', with: updated_content
            click_on "Update Post"
          end
          
          # Since the user hasn't been redirected after encountering an error with updating, 
          # this confirms that they are still on the show page and Turbo Streams is working.
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content("Body Post description length exceeded")
          expect(page).to have_selector('form')
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders show page using Turbo Streams" do
          edit_post_frame = find("turbo-frame#post_#{post.id}")
          within(edit_post_frame) do
            click_on 'Edit'
            click_on "Update Post"
          end

          cancel_btn = find_link('Cancel')
          expect(page).to_not have_content(cancel_btn)
          expect(page).to have_current_path(post_path(post))
        end
      end
    end
  end

  describe "Unauthorized Access" do
    context "when trying to edit a post that isnt the logged in user's post" do
      it "redirects to index page and shows error message" do
        unauthorized_post = create(:post)
        visit edit_post_path(unauthorized_post)
        expect(page).to have_content("You can only edit the posts that you have created.")
      end
    end
  end
end
