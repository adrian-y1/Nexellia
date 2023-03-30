class UsersController < ApplicationController
  def index
    @users = User.not_friends_with(current_user)
    @friend_request = FriendRequest.new
  end
end
