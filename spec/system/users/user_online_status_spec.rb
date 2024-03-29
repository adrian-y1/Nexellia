require 'rails_helper'

RSpec.describe "User Online Status", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }

  before do
    create(:friendship, user: user, friend: friend)
    driven_by(:selenium_chrome_headless)
  end

  context "when a user's friend logs in" do
    it "updates their status to online in real-time" do
      using_session :user do
        login_as(user)
        visit posts_path
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        expect(page).to have_css("span[class='post-index-contacts__status--offline']")
      end

      using_session :friend do
        login_as(friend)
        visit posts_path
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        expect(page).to have_css("span[class='post-index-contacts__status--online']")
      end

      using_session :user do
        expect(page).to have_css("span[class='post-index-contacts__status--online']")
      end
    end
  end

  context "when a user's friend logs out" do
    it "updates their status to offline in real-time" do
      using_session :user do
        login_as(user)
        visit posts_path
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
      end

      using_session :friend do
        login_as(friend)
        visit posts_path
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
      end

      # Reload the page so the user gets disconnected from the stream
      using_session :user do
        find_button(class: "navbar__user-dropdown--toggle").click
        click_on "Log out"
        visit current_path
      end

      using_session :friend do
        expect(page).to have_css("span[class='post-index-contacts__status--offline']")
      end
    end
  end
end