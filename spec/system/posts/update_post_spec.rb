require 'rails_helper'

RSpec.describe "Posts::UpdatePosts", type: :system do
  let(:user) { create(:user) }
  let(:uri_error) { URI::InvalidURIError }

  before do
    driven_by(:rack_test)
    login_as(user)
  end

  describe "Index Page" do
    before do
      post = create(:post, user: user)
      visit posts_path
      click_on 'Edit'
    end

    describe "Valid Attributes" do
      context "when updating a post" do
        it "updates the post" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'
          fill_in 'post[body]', with: updated_content
          click_on "Update Post"
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end
    end
  
    describe "Invalid Attributes" do
      context "when updating a post with empty body" do
        it "Fails to update the post with empty content and shows error message" do
          fill_in 'post[body]', with: ''
          expect { click_button 'Update Post' }.to raise_error(uri_error)
          expect(page).to have_content("Body can't be blank")
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and shows error message" do
          updated_content = Faker::Lorem.characters(number: 300)
          fill_in 'post[body]', with: updated_content
          expect { click_button 'Update Post' }.to raise_error(uri_error)
          expect(page).to have_content("Body Post description length exceeded")
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders index page" do
          cancel_btn = find_link('Cancel')
          click_on 'Cancel'
          expect(page).to_not have_content(cancel_btn)
          expect(page).to have_current_path(posts_path)
        end
      end
    end
  end

  describe "Show Page" do
    let(:post) { create(:post, user: user) }

    before do
      visit post_path(post)
      click_on 'Edit'
    end

    describe "Valid Attributes" do
      context "when updating a post" do
        it "updates the post" do
          updated_content = 'I updated the post.'
          flash_notice = 'Post was successfully updated.'
          fill_in 'post[body]', with: updated_content
          click_on "Update Post"
          expect(page).to have_content(updated_content)
          expect(page).to have_content(flash_notice)
        end
      end
    end
  
    describe "Invalid Attributes" do
      context "when updating a post with empty body" do
        it "Fails to update the post with empty content and shows error message" do
          fill_in 'post[body]', with: ''
          expect { click_button 'Update Post' }.to raise_error(uri_error)
          expect(page).to have_content("Body can't be blank")
        end
      end
  
      context "when updating a post with body length > 255" do
        it "Fails to update the post with empty content and shows error message" do
          updated_content = Faker::Lorem.characters(number: 300)
          fill_in 'post[body]', with: updated_content
          expect { click_button 'Update Post' }.to raise_error(uri_error)
          expect(page).to have_content("Body Post description length exceeded")
        end
      end
    end

    describe "Cancel" do
      context "when user clicks on cancel instead of update post" do
        it "closes the update form and renders show page" do
          cancel_btn = find_link('Cancel')
          click_on 'Cancel'
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
