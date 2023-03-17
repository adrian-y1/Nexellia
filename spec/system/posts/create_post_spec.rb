require 'rails_helper'

RSpec.describe "Posts::CreatePosts", type: :system do
  before do
    driven_by(:rack_test)
    login_as(create(:user))
  end

  # Steps: Login => visit new_post_path => fill in the form => submit
  # Since im using TurboStreams, the form is in posts_path (index), 
  # i dont need to visit/redirect to posts_path otherwise i wont see the flash notice
  context "when creating a post with valid attributes" do
    it "creates the post" do
      content = 'My New Post!'
      flash_notice = 'Post was successfully created.'
      visit new_post_path
      fill_in 'post[body]', with: content
      click_on 'Create Post'
      expect(page).to have_content(content)
      expect(page).to have_content(flash_notice)
    end
  end

  context "when creating a post with invalid attributes" do
    it "doesn't create the post and renders an error" do
      visit new_post_path
      fill_in 'post[body]', with: ''
      click_on 'Create Post'
      expect(page).to have_content("Body can't be blank")
    end
  end
end
