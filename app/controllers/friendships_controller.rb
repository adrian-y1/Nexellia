class FriendshipsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @friend = User.find(params[:friend_id])
    @friendship = current_user.create_friendship(@friend)

    # Once two users become friends, delete their friend request
    @friend_request = current_user.friend_requests_received.find_by(sender: @friend)
    if @friend_request
      broadcast_friend_creation(@friend_request)
      @friend_request.delete
    end

    respond_to do |format|
      format.turbo_stream 
      format.html { redirect_to request.referrer, notice: "You and #{@friend.username} are now friends!" }
    end
  end

  private

  def broadcast_friend_creation(friend_request)
    sender_stream = [friend_request.sender.id, friend_request.receiver.id]
    receiver_stream = [friend_request.receiver.id, friend_request.sender.id]
    sender_stream_locals = { logged_in_user: friend_request.sender, user: friend_request.receiver, friend_request: friend_request }
    receiver_stream_locals = { logged_in_user: friend_request.receiver, user: friend_request.sender, friend_request: friend_request }
    sender_frame, receiver_frame = dom_id(friend_request.sender), dom_id(friend_request.receiver)
    
    badge = "<span class='badge bg-success'>Friends</span>"
    
    Turbo::StreamsChannel.broadcast_replace_to sender_stream, target: receiver_frame, html: badge, 
    locals: sender_stream_locals
    
    Turbo::StreamsChannel.broadcast_replace_to receiver_stream, target: sender_frame, html: badge, 
    locals: receiver_stream_locals
  end
end
