class UsersController < ApplicationController
  before_action :load_user, only: %i[show friends]
  def index
    # eager load Profile and :profile_attachment to solve N + 1 queries problem
    @users = User.excluding_friends_and_requests(current_user).load_profiles
    @friend_request = FriendRequest.new
    @friend_requests = current_user.friend_requests_sent.or(current_user.friend_requests_received)
  end

  def show
    set_variables
    @pagy, @posts = pagy(@user.posts.includes(image_attachment: :blob).order(id: :desc), items: 5)
    mark_notification_as_read
    @friends = @user.friends.load_profiles.limit(9)
    render "posts/paginated_posts_list" if params[:page]
  end

  def friends
    set_variables
    mark_notification_as_read
    if params[:query].present?
      @friends = @user.friends.by_first_last_name(params[:query]).load_profiles
    else
      @friends = @user.friends.load_profiles
    end
    render 'show'
  end
  
  private

  # Mark the the current_user's notification as read if the notification_id parameter exists
  def mark_notification_as_read
    if params[:notification_id]
      @notification = Notification.find_by(id: params[:notification_id], recipient: current_user)
      @notification.mark_as_read! if @notification
    end
  end

  def load_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def set_variables
    @profile = @user.profile
    @friend_request = FriendRequest.new
    @is_current_user = current_user == @user
    @friends_count = @user.friends.count
  end
end
