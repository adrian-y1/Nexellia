require 'rails_helper'

RSpec.describe "Create Comment", type: :system do
  let(:user) { create(:user) }
  
  before do
    driven_by(:rack_test)
    login_as(user)
  end

  # Im rendering the create comment form under the post, and the post is rendered in posts_path (index page) 
  # the comment form is under the respective post and since im using Turbo Streams,
  # i dont need to visit/redirect to posts_path since im already there otherwise i wont see the flash notice
  describe "Valid Attributes" do
    it "creates the comment with Turbo Streams" do
      post = create(:post, user: user)
      content = "I just commented!"
      flash_notice = 'Comment was successfully created.'
      visit new_post_comment_path(post)
      fill_in 'comment[body]', with: content
      click_on 'Create Comment'

      # Since the user hasn't been redirected after creating a comment on a post,
      # this confirms that they are still on the index page and Turbo Streams is working.
      expect(page).to have_content(content)
      expect(page).to have_content(flash_notice)
      expect(page.current_url).to eq(posts_url)
    end
  end

  describe "invalid Attributes" do
    it "doesn't create the comment and renders an error with Turbo Streams" do
      post = create(:post, user: user)
      visit new_post_comment_path(post)
      fill_in 'comment[body]', with: ''
      click_on 'Create Comment'

      # Since the user hasn't been redirected after encountering an error with creating a comment,
      # this confirms Turbo Streams is working and that they are on the comments#index page.
      expect(page).to have_content("Body can't be blank")
      expect(page).to have_current_path(post_comments_path(post))
    end
  end
end