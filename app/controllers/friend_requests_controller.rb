class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests_sent.build(friend_request_params)

    respond_to do |format|
      if @friend_request.save
        notice_message = "Friend request has been sent to #{@friend_request.receiver.username}!"

        format.turbo_stream { flash.now[:notice] = notice_message }
        format.html { redirect_to request.referrer, notice: notice_message }
      else
        @friend_request.errors.full_messages.each { |message| flash[:alert] = message }
        format.html { redirect_to request.referrer, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @friend_request = FriendRequest.find_by(sender_id: params[:sender_id], receiver_id: params[:receiver_id])
    
    respond_to do |format|
      if @friend_request
        @receiver_username = @friend_request.receiver.username
        @sender_username = @friend_request.sender.username
        @friend_request.destroy

        format.turbo_stream { flash.now[:notice] = destroy_alert_message(@sender_username, @receiver_username) }
        format.html { redirect_to request.referrer, notice: destroy_alert_message(@sender_username, @receiver_username) }
      else
        format.html {redirect_to request.referrer, status: :unprocessable_entity, alert: "Error while cancelling friend request."}
      end
    end
  end

  private

  def destroy_alert_message(sender_username, receiver_username)
    receiver_msg = "You have declined #{sender_username}'s friend request."
    sender_msg = "Friend request to #{receiver_username} has been cancelled."
    sender_username == current_user.username ? sender_msg : receiver_msg
  end

  def friend_request_params
    params.require(:friend_request).permit(:sender_id, :receiver_id)
  end
  
end
