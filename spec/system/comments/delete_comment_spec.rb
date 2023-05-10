# This file contains system tests for deleting comments using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/comments/delete_comment_spec.rb

require 'rails_helper'

RSpec.describe "Delete Comment", type: :system, js: true do
  let(:user) { create(:user) }
  let(:flash_notice) { "Comment was successfully deleted." }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # These tests check comment deletion inside using Turbo Streams.
  #
  # With the help of Turbo Frames, i don't need to visit a seperate page to 
  # access the delete button as it is displayed on the comment itself.
  # 
  # The expect statements ensure that the comment is successfully deleted and that a flash notice is
  # displayed to the user. They also confirm that Turbo Streams is working by checking
  # that the comment is deleted live without a page refresh.

  describe "posts#show Page" do
    let!(:post) { create(:post, user: user) }
    let!(:comment) { create(:comment, commentable: post, user: user) }

    it "deletes the comment and renders flash notice using Turbo Streams" do
      post = user.posts.last
      visit post_path(post)

      expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

      comment_frame = find("turbo-frame#comment_#{comment.id}")
      within(comment_frame) do
        click_on "Delete"
      end

      # Confirms that the comment was deleted live using Turbo Streams and that 
      # the user is still on the posts#show page.
      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content(flash_notice)
    end

    it "deletes the comment and all its replies using Turbo Streams" do
      reply1 = create(:comment, commentable: comment, parent: comment, user: user)
      reply2 = create(:comment, commentable: comment, parent: reply2, user: user)
      reply3 = create(:comment, commentable: comment, parent: reply3, user: user)
      reply4 = create(:comment, commentable: comment, parent: reply4, user: user)

      visit post_path(post)

      expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)

      comment_frame = find("turbo-frame#comment_#{comment.id}")
      within(comment_frame) do
        all('a', text: 'Delete')[0].click
      end
     
      expect(page).to have_current_path(post_path(post))
      expect(page).not_to have_content([reply4.body, reply3.body, reply2.body, reply1.body])
      expect(page).to have_content(flash_notice)
    end
  end
end