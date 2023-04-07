class UsersController < ApplicationController
  def index
    @users = User.excluding_user(current_user)
    @friendship = current_user.friends.new
    @friend_request = FriendRequest.new
  end
end
