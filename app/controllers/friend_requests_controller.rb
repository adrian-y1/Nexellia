class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests_sent.build(friend_request_params)

    respond_to do |format|
      if @friend_request.save
        notice_message = "Friend request has been sent to #{@friend_request.receiver.full_name}!"

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
        @friend_request.destroy

        format.turbo_stream { flash.now[:notice] = destroy_alert_message }
        format.html { redirect_to request.referrer, notice: destroy_alert_message }
      else
        format.html {redirect_to request.referrer, status: :unprocessable_entity, alert: "Error while cancelling friend request."}
      end
    end
  end

  private

  def destroy_alert_message
    receiver_msg = "You have declined #{ @friend_request.sender.full_name}'s friend request."
    sender_msg = "Friend request to #{ @friend_request.receiver.full_name} has been cancelled."
    @friend_request.sender.full_name == current_user.full_name ? sender_msg : receiver_msg
  end

  def friend_request_params
    params.require(:friend_request).permit(:sender_id, :receiver_id)
  end
  
end
