require 'rails_helper'

RSpec.describe "Create Post", type: :system do
  before do
    driven_by(:rack_test)
    login_as(create(:user))
  end

  # Steps: Login => visit new_post_path => fill in the form => submit
  # Since im using TurboStreams, the form is in posts_path (index), 
  # i dont need to visit/redirect to posts_path otherwise i wont see the flash notice
  describe "Valid Attributes" do
    it "creates the post with Turbo Streams" do
      content = 'My New Post!'
      flash_notice = 'Post was successfully created.'
      visit new_post_path
      fill_in 'post[body]', with: content
      click_on 'Create Post'

      # Since the user hasn't been redirected after creating a post,
      # this confirms that they are still on the index page Turbo Streams is working.
      expect(page).to have_content(content)
      expect(page).to have_content(flash_notice)
      expect(page.current_url).to eq(posts_url)
    end
  end

  describe "Invalid Attributes" do
    it "doesn't create the post and renders an error with Turbo Streams" do
      visit new_post_path
      fill_in 'post[body]', with: ''
      click_on 'Create Post'
      
      # Since the user hasn't been redirected after creating a post,
      # this confirms that they are still on the index page Turbo Streams is working.
      expect(page).to have_content("Body can't be blank")
      expect(page.current_url).to eq(posts_url)
    end
  end
end
