require 'rails_helper'

RSpec.describe "Posts::DeletePosts", type: :system do
  let(:user) { create(:user) }
  let(:flash_notice) { "Post was successfully deleted."}

  before do
    driven_by(:rack_test)
    login_as(user)
  end

  context "when deleting a post in the index page" do
    it "deletes the post, stays on the index page and renders flash notice" do
      post = create(:post, user: user)
      visit posts_path
      expect(page).to have_content(post.body)

      click_on "Delete"
      expect(page).not_to have_content(post.body)
      expect(page).to have_content(flash_notice)
    end
  end

  context "when deleting a post in the show page" do
    it "deletes the post, renders flash notice and redirects to index page" do
      post = create(:post, user: user)
      visit post_path(post)
      expect(page).to have_content(post.body)

      click_on "Delete"
      expect(page).to have_content(flash_notice)
      
      visit posts_path
      expect(page).not_to have_content(post.body)
    end
  end
end