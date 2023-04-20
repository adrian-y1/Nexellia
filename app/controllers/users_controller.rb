class UsersController < ApplicationController
  def index
    # eager load Profile and :profile_attachment to solve N + 1 queries problem
    @users = User.excluding_user(current_user).includes(profile: :picture_attachment)
    @friendship = current_user.friends.new
    @friend_request = FriendRequest.new
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @posts = @user.posts
    @friend_request = FriendRequest.new
    @is_current_user = current_user == @user
  end
end
