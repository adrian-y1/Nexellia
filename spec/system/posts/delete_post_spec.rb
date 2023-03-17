require 'rails_helper'

RSpec.describe "Delete Post", type: :system do
  let(:user) { create(:user) }
  let(:flash_notice) { "Post was successfully deleted."}

  before do
    driven_by(:rack_test)
    login_as(user)
  end

  describe "Index Page" do
    it "deletes the post and renders flash notice using Turbo Streams" do
      post = create(:post, user: user)
      visit posts_path
      expect(page).to have_content(post.body)

      click_on "Delete"

      # Confirms that the user has not been redirected after deleting post,
      # and is still on the index page. Meaning that Turbo Streams works.
      expect(page).not_to have_content(post.body)
      expect(page).to have_content(flash_notice)
      expect(page.current_url).to eq(posts_url)
    end
  end

  describe "Show Page" do
    it "deletes the post, renders flash notice and redirects to index page using Turbo Streams" do
      post = create(:post, user: user)
      visit post_path(post)
      expect(page).to have_content(post.body)

      click_on "Delete"
      
      # Confirms that Turbo Streams works as the tag is included in the page.
      expect(page).to have_content(flash_notice)
      expect(page).to have_css('turbo-cable-stream-source', visible: false)

      visit posts_path
      expect(page).not_to have_content(post.body)
    end
  end
end