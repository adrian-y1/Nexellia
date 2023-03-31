class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests_sent.build(friend_request_params)

    if @friend_request.save
      redirect_to request.referrer, notice: "Friend request has been sent to #{@friend_request.receiver.username}!"
    else
      redirect_to request.referrer, status: :unprocessable_entity, alert: "Error while sending friend request."
    end
  end

  def destroy
    @friend_request = current_user.friend_requests_sent.find_by(receiver_id: params[:receiver_id])
    
    if @friend_request
      @receiver_username = @friend_request.receiver.username
      @friend_request.destroy
      redirect_to request.referrer, notice: "Friend request to #{@receiver_username} has been cancelled."
    else
      redirect_to request.referrer, status: :unprocessable_entity, alert: "Error while cancelling friend request."
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:receiver_id)
  end
  
end
