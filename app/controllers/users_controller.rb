class UsersController < ApplicationController
  def index
    # eager load Profile and :profile_attachment to solve N + 1 queries problem
    @users = User.excluding_user(current_user).includes(profile: :picture_attachment)
    @friend_request = FriendRequest.new
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @pagy, @posts = pagy(@user.posts.includes(image_attachment: :blob).order(id: :desc), items: 5)
    @friend_request = FriendRequest.new
    @is_current_user = current_user == @user
    mark_notification_as_read
    @friends = @user.friends.load_profiles
    @friends_count = @friends.count
    render "posts/paginated_posts_list" if params[:page]
  end
  
  private

  # Mark the the current_user's notification as read if the notification_id parameter exists
  def mark_notification_as_read
    if params[:notification_id]
      @notification = Notification.find_by(id: params[:notification_id], recipient: current_user)
      @notification.mark_as_read! if @notification
    end
  end
end
