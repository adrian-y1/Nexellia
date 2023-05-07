# This file contains system tests for removing a friend using Turbo Streams. 
#
# These tests are created using Rspec + Capybara + Capybara's selenium drive
#
# To run the tests, run => rspec spec/system/friendships/removing_friend_spec.rb

require "rails_helper"

RSpec.describe "Remove Friend", type: :system, js: true do 
  let(:user) { create(:user) }

  before do
    login_as(user)
    driven_by(:selenium_chrome_headless)
  end

  # First, ensure that the subscription to the stream has been connected before the broadcast gets called to avoid flaky tests
  #
  # Then, Remove the friend by clicking the 'Remove' button after finding the Turbo Frame
  # that is wrapped around it. Due to having a Turbo Frame tag, a visit to another page is not needed.
  #
  # Lastly, the expectations for the flash notice, 'Friends' tag not being displayed and the current path, ensures
  # that the user is receiving updates as they happen in real-time, without a page refresh/reload.
  # Meaning Turbo Streams is working.
  
  describe "users#index page" do
    # This test checks the functionality for removing a friend on the
    # users#index page using Turbo Streams.
    
    context "when clicking the Remove button on the users#index page" do
      it "successfully removes the friend on the users#index page using Turbo Streams" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        create(:friendship, user: user, friend: new_user)
        
        visit users_path
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        expect(page).to have_content("Friends")

        friend_frame = find("turbo-frame#user_#{new_user.id}")
        within(friend_frame) do
          click_on "Remove"
        end
        
        expect(page).to have_content("You and #{new_user.full_name} are no longer friends!")
        expect(page).to have_current_path(users_path)
        expect(page).to_not have_content("Friends")
      end
    end
  end

  describe "users#show page" do
    # This test checks the functionality for removing a friend on the
    # users#show page using Turbo Streams.
    
    context "when clicking the Remove button on the users#show page" do
      it "successfully removes the friend on the users#show page using Turbo Streams" do
        new_user = create(:user)
        create(:friend_request, sender: new_user, receiver: user)
        create(:friendship, user: user, friend: new_user)
        
        visit user_path(new_user)
        
        expect(page).to have_css('turbo-cable-stream-source[connected]', visible: false)
        expect(page).to have_content("Friends")
        
        friend_frame = find("turbo-frame#user_#{new_user.id}")
        within(friend_frame) do
          click_on "Remove"
        end
        
        expect(page).to have_content("You and #{new_user.full_name} are no longer friends!")
        expect(page).to have_current_path(user_path(new_user))
        expect(page).to_not have_content("Friends")
      end
    end
  end
end
