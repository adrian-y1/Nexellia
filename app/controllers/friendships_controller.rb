class FriendshipsController < ApplicationController
  def create
    @friend = User.find(params[:friend_id])
    @friendship = current_user.create_friendship(@friend)

    # Once two users become friends, delete their friend request
    @friend_request = current_user.friend_requests_received.find_by(sender: @friend)
    @friend_request.destroy if @friend_request
    
    redirect_to request.referrer, notice: "You and #{@friend.username} are now friends!"
  end
end
