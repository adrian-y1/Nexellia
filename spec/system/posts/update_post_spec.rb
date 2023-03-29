# This file contains system tests for updating posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/update_post_spec.rb

require 'rails_helper'

RSpec.describe "Update Post", type: :system, js: true do
  let(:user) { create(:user) }

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
      #
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate 
      # page to access it. Once the 'Edit' button is clicked, the edit form is then rendered inside 
      # the 'modal' Turbo Frame Tag that is in application.html.erb.
      #
      # Since i'm using Turbo Streams, instead of a full page refresh, 
      # the post is updated live and the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.
      
      context "when updating a post" do
        it "updates the post using Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          # First click on "Edit" button to render the form inside the 'modal' Turbo Frame Tag
          # and make it visibile
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
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

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: ''
            click_on "Update Post"
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

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on "Update Post"
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

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found. Including the 'Cancel' button.
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found. Including the 'Cancel' button.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            click_on "Cancel"
          end

          expect(page).to have_current_path(posts_path)
          expect(page).to have_content(user.posts.last.body)
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
      # the post is updated live and the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.

      context "when updating a post" do
        it "updates the post with Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
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

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
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

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
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
          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found. Including the 'Cancel' button.
          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            click_on 'Edit'
          end

          # After the "Edit" button is clicked, the form is rendered in the 'modal' Turbo Frame Tag
          # and is visible to be found. Including the 'Cancel' button.
          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            click_on "Cancel"
          end

          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content(user.posts.last.body)
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
