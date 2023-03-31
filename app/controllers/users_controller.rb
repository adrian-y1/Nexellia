class UsersController < ApplicationController
  def index
    @users = User.not_friends_with(current_user)
    @friendship = current_user.friends.new
    @friend_request = FriendRequest.new
  end
end
