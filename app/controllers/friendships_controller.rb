class FriendshipsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @friend = User.find(params[:friend_id])
    @friendship = current_user.create_friendship(@friend)

    # Once two users become friends, delete their friend request
    @friend_request = current_user.friend_requests_received.find_by(sender: @friend)
    if @friend_request
      broadcast_friend_creation(@friend_request, @friend)
      FriendshipNotification.with(friendship: @friendship).deliver(@friend_request.sender)
      destroy_notifications(@friend_request)
      @friend_request.delete
    end

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "You and #{@friend.username} are now friends!" }
      format.html { redirect_to request.referrer, notice: "You and #{@friend.username} are now friends!" }
    end
  end

  def destroy
    @friend = User.find(params[:friend_id])
    current_user.destroy_friendship(@friend)

    respond_to do |format|
      broadcast_friend_destruction(@friend)

      format.turbo_stream { flash.now[:notice] = "You and #{@friend.username} are no longer friends!" }
      format.html { redirect_to request.referrer, notice: "You and #{@friend.username} are no longer friends!" }
    end
  end

  private

  def broadcast_friend_creation(friend_request, friend)
    sender_stream = [friend_request.sender.id, friend_request.receiver.id]
    receiver_stream = [friend_request.receiver.id, friend_request.sender.id]
    sender_stream_locals = { logged_in_user: friend_request.sender, user: friend_request.receiver, friend_request: friend_request }
    receiver_stream_locals = { logged_in_user: friend_request.receiver, user: friend_request.sender, friend_request: friend_request }
    sender_frame, receiver_frame = dom_id(friend_request.sender), dom_id(friend_request.receiver)

    # Broadcast the changes to the sender's stream
    Turbo::StreamsChannel.broadcast_replace_to sender_stream, target: receiver_frame, partial: "users/friend_request_form", 
      locals: sender_stream_locals
    
    # Broadcast the changes to the receiver's stream
    Turbo::StreamsChannel.broadcast_replace_to receiver_stream, target: sender_frame, partial: "users/friend_request_form", 
      locals: receiver_stream_locals
  end

  def broadcast_friend_destruction(friend)
    # Broadcast the changes to the person removing their friend
    Turbo::StreamsChannel.broadcast_replace_to [current_user.id, friend.id], target: dom_id(friend), partial: "users/friend_request_form",
      locals: { logged_in_user: Current.user, user: friend, friend_request: FriendRequest.new  }

    # Broadcast the changes to the person that is getting removed
    Turbo::StreamsChannel.broadcast_replace_to [friend.id, current_user.id], target: dom_id(current_user), partial: "users/friend_request_form",
      locals: { logged_in_user: friend, user: Current.user, friend_request: FriendRequest.new }
  end

  # Destroys all notifications associated with this friend request
  def destroy_notifications(friend_request)
    notifications = Notification.where(recipient_id: friend_request.receiver, type: "FriendRequestNotification", params: { message: friend_request })
    notifications.destroy_all
  end
end
