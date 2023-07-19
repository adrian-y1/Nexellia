class UsersController < ApplicationController
  before_action :load_user, only: %i[show friends]

  include ProfilesHelper

  def index
    # Eager load Profile and :profile_attachment to solve N + 1 queries problem
    @users = User.excluding_friends_and_requests(current_user).load_profiles
    @friend_request = FriendRequest.new
    @friend_requests = current_user.friend_requests_sent.or(current_user.friend_requests_received)

    respond_to do |format|
      format.html
      format.json { render json: jsonified_users }
    end
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

    respond_to do |format|
      format.html { render "show" }
      format.json { render json: jsonified_friends }
    end
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
    @mutual_friends = current_user.mutual_friends(@user).load_profiles.limit(9)
    @mutual_friends_count = current_user.mutual_friends(@user).count
  end

  def jsonified_users
    User.load_profiles.map do |user|
      {
        id: user.id,
        name: user.full_name,
        picture: picture_url(user)
      }
    end
  end

  def jsonified_friends
    @user.friends.load_profiles.map do |friend|
      {
        id: friend.id,
        name: friend.full_name,
        picture: profile_picture_for(friend.profile)
      }
    end
  end

  def picture_url(user)
    picture = profile_picture_for(user.profile, "40x40")
    if picture.is_a?(ActiveStorage::Attached::One)
      return picture.url
    else
      return picture
    end
  end
end
