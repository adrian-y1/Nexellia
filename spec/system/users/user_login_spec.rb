require 'rails_helper'

RSpec.describe 'User Login', type: :system do
  let(:user) { create(:user) }

  before do 
    driven_by(:rack_test)
    visit new_user_session_path
  end

  describe "Valid Attributes" do
    it "logs the user in" do
      fill_in 'user[username]', with: user.username
      fill_in 'user[password]', with: user.password
      click_on 'Log in'
      expect(page).not_to have_current_path(new_user_session_path)
      expect(page).to have_content('Signed in successfully.')
    end
  end

  describe "Invalid Attributes" do
    let(:error_message) { "Invalid Username or password." }

    context "when the user credentials are invalid" do
      it "fails to log the user in and shows an error message" do
        fill_in 'user[username]', with: 'michael'
        fill_in 'user[password]', with: 'scott'
        click_on 'Log in'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content(error_message)
      end
    end

    context "when the username is not provided" do
      it "fails to log the user in and shows an error message" do
        fill_in 'user[username]', with: ''
        fill_in 'user[password]', with: user.password
        click_on 'Log in'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content(error_message)
      end
    end

    context "when the password is not provided" do
      it "fails to log the user in and shows an error message" do
        fill_in 'user[username]', with: user.username
        fill_in 'user[password]', with: ''
        click_on 'Log in'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content(error_message)
      end
    end
  end
end