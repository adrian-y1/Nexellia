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
    # Tests that a post can be successfully created using the create post form on the index page.
    # Uses Capybara to fill in the form and submit it. The post is created live with Turbo Streams,
    # and the user is not redirected to a new page. Confirms that the post is created, a flash notice
    # is displayed, and Turbo Streams is working.

    context "when the post body is valid" do
      it "creates the post live with Turbo Streams" do
        visit posts_path
  
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
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

    context "when the image is of type PNG" do
      it "creates the post live with Turbo Streams" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          attach_file('post[image]', 'spec/fixtures/files/avatar2.png')
          click_on 'Create Post'
        end

        expect(page).to have_content(content)
        expect(page).to have_css('img[src$="avatar2.png"]')
        expect(page).to have_content(flash_notice)
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when the image is of type JPG" do
      it "creates the post live with Turbo Streams" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          attach_file('post[image]', 'spec/fixtures/files/testing_image.jpg')
          click_on 'Create Post'
        end

        expect(page).to have_content(content)
        expect(page).to have_css('img[src$="testing_image.jpg"]')
        expect(page).to have_content(flash_notice)
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when the image is of type JPEG" do
      it "creates the post live with Turbo Streams" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          attach_file('post[image]', 'spec/fixtures/files/testing_image.jpeg')
          click_on 'Create Post'
        end

        expect(page).to have_content(content)
        expect(page).to have_css('img[src$="testing_image.jpeg"]')
        expect(page).to have_content(flash_notice)
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when the image is of type GIF" do
      it "creates the post live with Turbo Streams" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          attach_file('post[image]', 'spec/fixtures/files/test.gif')
          click_on 'Create Post'
        end

        expect(page).to have_content(content)
        expect(page).to have_css('img[src$="test.gif"]')
        expect(page).to have_content(flash_notice)
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when post body is provided but image is not provided" do
      it "creates the post live with Turbo Streams" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          click_on 'Create Post'
        end

        expect(page).to have_content(content)
        expect(page).to have_content(flash_notice)
        expect(page).to have_current_path(posts_path)
      end
    end
  end

  describe "Invalid Attributes" do
    # Tests that a post cannot be successfully created using the create post form on the index page when 
    # it has invalid attributes.
    # Uses Capybara to fill in the form and submit it. The post is created live with Turbo Streams,
    # and the user is not redirected to a new page. Confirms that the post is created, a flash notice
    # is displayed, and Turbo Streams is working.
    
    context "when the post body is empty" do
      it "doesn't create the post and renders an error without page referesh" do
        visit posts_path
  
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: ''
          click_on 'Create Post'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content("Body can't be blank")
      end
    end

    context "when the image is not of type PNG, JPG, JPEG or GIF" do
      it "doesn't create the post and renders an error without page referesh" do
        visit posts_path

        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: content
          attach_file('post[image]', 'spec/fixtures/files/text.txt')
          click_on 'Create Post'
        end

        expect(page).to_not have_css('img[src$="text.txt"]')
        expect(page).to have_content('Image needs to be a JPEG, JPG, PNG or GIF')
        expect(page).to have_current_path(posts_path)
      end
    end

    context "when post body is not provided but image is provided" do
      it "doesn't create the post and renders an error without page referesh" do
        visit posts_path
  
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
  
        new_post_frame = find("turbo-frame[id='new_post']")
        within(new_post_frame) do
          fill_in 'post[body]', with: ''
          attach_file('post[image]', 'spec/fixtures/files/avatar2.png')
          click_on 'Create Post'
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content("Body can't be blank")
      end
    end
  end
end
