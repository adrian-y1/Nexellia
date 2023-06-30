# This file contains system tests for updating posts using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/update_post_spec.rb

require 'rails_helper'

RSpec.describe 'Save Post', type: :system, js: true do
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index Page" do
    # The following tests test the update post functionality with Turbo Streams inside the posts#index page.
    # They test valid & invalid attributes to cover all bases with updating posts.
    
    before do
      post = create(:post, user: user)
      visit posts_path
      
    end

    describe "Valid Attributes" do
      # These tests check that a post can be successfully updated using the edit form modal of a post.
      #
      # Once the 'Edit' button is clicked, the edit form is then rendered inside 
      # the 'modal' Turbo Frame Tag that is in application.html.erb.
      #
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate page to access it. 
      # After the post is filled and updated, the changes happen in real-time without page reload and 
      # the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.
      
      context "when post body is provided" do
        it "updates the post using Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          # First click on "Edit" button to render the form inside the 'modal' Turbo Frame Tag
          # and make it visibile
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end

      context "when image is of type PNG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/avatar2.png', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_css('img[src$="avatar2.png"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_css('img[src$="testing_image.jpg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPEG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpeg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_css('img[src$="testing_image.jpeg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type GIF" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/test.gif', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_css('img[src$="test.gif"]')
          expect(page).to have_content('Post was successfully updated.')
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
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
    
          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: ''
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('form')
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and shows error message using Turbo Streams" do
          updated_content = Faker::Lorem.characters(number: 300)

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end

          expect(page).to have_current_path(posts_path)
          expect(page).to have_content("Body Post description length exceeded")
          expect(page).to have_selector('form')
        end
      end

      context "when image is not of type PNG, JPG, JPEG or GIF" do
        it "fails to update the post and shows error message using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/text.txt', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(posts_path)
          expect(page).not_to have_css('img[src$="text.txt"]')
          expect(page).to have_content('Image needs to be a JPEG, JPG, PNG or GIF')
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders posts#index page using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            find_button(class: "modal__header--close").click
          end

          expect(page).to have_current_path(posts_path)
          expect(page).to have_content(user.posts.last.body)
        end
      end
    end
  end

  describe "posts#show Page" do
    # The following tests test the update post functionality with Turbo Streams inside the posts#show page.
    # They test valid & invalid attributes to cover all bases with updating posts.

    let(:post) { create(:post, user: user) }

    before do
      visit post_path(post)
    end

    describe "Valid Attributes" do
      # These tests check that a post can be successfully updated using the edit form modal of a post.
      #
      # Once the 'Edit' button is clicked, the edit form is then rendered inside 
      # the 'modal' Turbo Frame Tag that is in application.html.erb.
      #
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate page to access it. 
      # After the post is filled and updated, the changes happen in real-time without page reload and 
      # the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.

      context "when post body is provided" do
        it "updates the post with Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end

          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end

      context "when image is of type PNG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/avatar2.png', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_css('img[src$="avatar2.png"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_css('img[src$="testing_image.jpg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPEG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpeg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_css('img[src$="testing_image.jpeg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type GIF" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/test.gif', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_css('img[src$="test.gif"]')
          expect(page).to have_content('Post was successfully updated.')
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
        it "Fails to update the post with empty content and posts#show error message using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: ''
            click_on 'Save Post'
          end

          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('form')
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and posts#show error message using Turbo Streams" do
          updated_content = Faker::Lorem.characters(number: 300)

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content("Body Post description length exceeded")
          expect(page).to have_selector('form')
        end
      end

      context "when image is not of type PNG, JPG, JPEG or GIF" do
        it "fails to update the post and shows error message using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/text.txt', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(post_path(post))
          expect(page).not_to have_css('img[src$="text.txt"]')
          expect(page).to have_content('Image needs to be a JPEG, JPG, PNG or GIF')
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders posts#show page using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{user.posts.last.id}")
          within(show_page_post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            find_button(class: "modal__header--close").click
          end

          expect(page).to have_current_path(post_path(post))
          expect(page).to have_content(user.posts.last.body)
        end
      end
    end
  end

  describe "users#show Page" do
    # The following tests test the update post functionality with Turbo Streams inside the users#show page.
    # They test valid & invalid attributes to cover all bases with updating posts.

    let(:post) { create(:post, user: user) }

    before do
      visit user_path(post.user)
    end

    describe "Valid Attributes" do
      # These tests check that a post can be successfully updated using the edit form modal of a post.
      #
      # Once the 'Edit' button is clicked, the edit form is then rendered inside 
      # the 'modal' Turbo Frame Tag that is in application.html.erb.
      #
      # Since the form is within a Turbo Frame tag, i do not need to visit a seperate page to access it. 
      # After the post is filled and updated, the changes happen in real-time without page reload and 
      # the user is not redirected to a new page.
      #
      # With this functionality in place, the test is able to check that, when a post is updated,
      # the updated content are updated live and the flash notice is displayed without 
      # a page refresh.

      context "when updating a post" do
        it "updates the post with Turbo Streams" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end

          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end

      context "when image is of type PNG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/avatar2.png', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_css('img[src$="avatar2.png"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_css('img[src$="testing_image.jpg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type JPEG" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/testing_image.jpeg', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_css('img[src$="testing_image.jpeg"]')
          expect(page).to have_content('Post was successfully updated.')
        end
      end

      context "when image is of type GIF" do
        it "updates the post using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/test.gif', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_css('img[src$="test.gif"]')
          expect(page).to have_content('Post was successfully updated.')
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
        it "Fails to update the post with empty content and users#show error message using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: ''
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('form')
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and users#show error message using Turbo Streams" do
          updated_content = Faker::Lorem.characters(number: 300)

          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            fill_in 'post[body]', with: updated_content
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).to have_content("Body Post description length exceeded")
          expect(page).to have_selector('form')
        end
      end

      context "when image is not of type PNG, JPG, JPEG or GIF" do
        it "fails to update the post and shows error message using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            attach_file('post[image]', 'spec/fixtures/files/text.txt', visible: false)
            click_on 'Save Post'
          end
          
          expect(page).to have_current_path(user_path(post.user))
          expect(page).not_to have_css('img[src$="text.txt"]')
          expect(page).to have_content('Image needs to be a JPEG, JPG, PNG or GIF')
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders users#show page using Turbo Streams" do
          expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

          post_interactions_frame = find("turbo-frame#post-interactions-#{user.posts.last.id}")
          within(post_interactions_frame) do
            find_button(class: "post-card__dropdown--trigger").click
            click_on 'Edit'
          end

          modal_form_frame = find("turbo-frame#modal")
          within(modal_form_frame) do
            find_button(class: "modal__header--close").click
          end

          expect(page).to have_current_path(user_path(post.user))
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
        expect(page).to have_content("404! The page you requested was not found.")
      end
    end
  end
end
