# This file contains system tests for a post's comments counter using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/posts/comment_counter_spec.rb

require 'rails_helper'

RSpec.describe "Post Comments Counter", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  describe "posts#index Page" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # in real-time inside the posts#index page using Turbo Streams.

    before do 
      create(:post, user: user)
      visit posts_path
    end
    
    context "when a comment is created" do
      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end
        
        find_button(class: "modal__header--close")

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comment is deleted" do
      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          all('button', class: "comment-card__dropdown--trigger")[0].click
          all('a', text: 'Delete')[0].click
        end

        find_button(class: "modal__header--close")

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('0 Comments')
      end
    end
  end

  describe "posts#show Modal" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # inside the posts#show Modal using Turbo Streams.

    before do 
      create(:post, user: user)
    end
    
    context "when a comment is created" do
      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        visit posts_path

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a reply to a comment is created" do
      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        visit posts_path

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_replies_element = find("div[id='comment_#{post.comments.last.id}_replies']")
        within(comment_replies_element) do
          click_on 'Reply'
          fill_in 'comment[body]', with: 'Replying to Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('2 Comments')
      end
    end

    context "when a comment is deleted" do
      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit posts_path

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Comment 1'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          all('button', class: "comment-card__dropdown--trigger")[0].click
          all('a', text: 'Delete')[0].click
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('0 Comments')
      end
    end


    context "when a reply to a comment is deleted" do
      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit posts_path

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_replies_element = find("div[id='comment_#{post.comments.last.id}_replies']")
        within(comment_replies_element) do
          click_on 'Reply'
          fill_in 'comment[body]', with: 'Replying to Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end
        expect(page).to have_content('2 Comments')
        reply_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(reply_frame) do
          all('button', class: "comment-card__dropdown--trigger")[0].click
          all('a', text: 'Delete')[0].click
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comments and all it's replies are deleted" do
      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit posts_path

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end
        
        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        comment_replies_element = find("div[id='comment_#{post.comments.last.id}_replies']")
        within(comment_replies_element) do
          click_on 'Reply'
          fill_in 'comment[body]', with: 'Replying to Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('2 Comments')

        reply_element = find("div[id='comment_#{post.comments.last.id}_replies']")
        within(reply_element) do
          click_on 'Reply'
          fill_in 'comment[body]', with: 'Replying to Commenting 2'
          find_button(class: "modal__footer__comments-form--button").click
        end
        expect(page).to have_content('3 Comments')
        within(comment_frame) do
          all('button', class: "comment-card__dropdown--trigger")[0].click
          all('a', text: 'Delete')[0].click
        end

        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('0 Comments')
      end
    end
  end

  describe "users#show Page" do
    # These tests check the incrementing and decrementing of the comments counter of a post
    # inside the users#show page using Turbo Streams.

    before do 
      create(:post, user: user)
    end
    
    context "when a comment is created" do
      let(:post) { user.posts.last }

      it "increments the comments counter live using Turbo Streams" do
        visit user_path(post.user)

        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end
        
        find_button(class: "modal__header--close")

        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content('1 Comment')
      end
    end

    context "when a comment is deleted" do
      let(:post) { user.posts.last }

      it "decrements the comments counter live using Turbo Streams" do
        visit user_path(post.user)

        expect(page).to have_content('0 Comments')

        post_interactions_frame = find("turbo-frame#post-interactions-#{post.id}")
        within(post_interactions_frame) do
          click_on 'Comment'
        end

        show_page_post_interactions_frame = find("turbo-frame#show-page-post-interactions-#{post.id}")
        within(show_page_post_interactions_frame) do
          fill_in 'comment[body]', with: 'Commenting'
          find_button(class: "modal__footer__comments-form--button").click
        end

        expect(page).to have_content('1 Comment')

        comment_frame = find("turbo-frame#comment_#{post.comments.last.id}")
        within(comment_frame) do
          all('button', class: "comment-card__dropdown--trigger")[0].click
          all('a', text: 'Delete')[0].click
        end

        find_button(class: "modal__header--close")
        
        expect(page).to have_current_path(user_path(post.user))
        expect(page).to have_content('0 Comments')
      end
    end
  end
end
