class UsersController < ApplicationController
  def index
    @users = User.not_friends_with(current_user)
  end
end
