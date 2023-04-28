class FriendshipsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    
    respond_to do |format|
      if @friendship.save
        @friend = @friendship.friend
        handle_friendship_broadcast

        format.turbo_stream { flash.now[:notice] = "You and #{@friend.username} are now friends!" }
        format.html { redirect_to request.referrer, notice: "You and #{@friend.username} are now friends!" }
      else
        format.html { redirect_to request.referrer, notice: "Error while creating friendship" }
      end
    end
  end

  def destroy
    @friendship = Friendship.find_by(user: current_user)
    @friend = @friendship.friend
    @friendship.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "You and #{@friend.username} are no longer friends!" }
      format.html { redirect_to request.referrer, notice: "You and #{@friend.username} are no longer friends!" }
    end
  end

  private 

  def handle_friendship_broadcast
    @friend_request = current_user.friend_requests_received.find_by(sender: @friend)

    if @friend_request
      @friendship.broadcast_friend_creation(@friend_request)
      @friend_request.destroy
    end
  end
end
