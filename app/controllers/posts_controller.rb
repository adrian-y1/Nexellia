class PostsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_post, only: [:edit, :update]
  
  def index
    @pagy, @posts = pagy(Post.user_and_friends_posts(current_user).includes(image_attachment: :blob), items: 5)
    @user_friends = current_user.friends.load_profiles

    render "paginated_posts_list" if params[:page]
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream { flash.now[:notice] = "Post was successfully created." }
        format.html { redirect_to posts_path, notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity, alert: "Post could not be created." }
      end
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    mark_notification_as_read
    redirect_to posts_url, alert: "The post you were viewing no longer exists." unless @post
  end

  def edit
    if current_user != @post.user
      redirect_to root_path, alert: "You can only edit the posts that you have created."
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream { flash.now[:notice] = "Post was successfully updated." }
        format.html { redirect_to posts_path, notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :see_other, alert: "Post could not be updated." }
      end
    end
  end

  def destroy
    @post = Post.includes(comments: [:comments, :likes, :parent]).find(params[:id])
    @post.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Post was successfully deleted." }
      format.html { redirect_to posts_url, notice: "Post was successfully deleted." }
    end
  end

  # Executes the #like(post) method inside user.rb model 
  # for the user instance with the given post
  # 
  # responds with a turbo_stream format that renders the #private_stream method
  def like
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream
      end
    end
  end

  private

  # Creates a private stream for only the current user.
  # This is done so only the current user's Like/Unlike button text is changed.
  #
  # turbo_stream.replace is used for the given private target in order to change the button's text
  # to either Like or Unlike
  # Since we are only using turbo_stream and not broadcasting this via the model, 
  # only the current user's button will get altered
  def private_stream
    @post = Post.find(params[:post_id])
    private_target = "#{dom_id(@post)} private_likes"
    turbo_stream.replace(private_target, partial: "likes/post_like_button", locals: { post: @post, like_status: current_user.liked?(@post) } )
  end

  # Mark the the current_user's notification as read if the notification_id parameter exists
  def mark_notification_as_read
    if params[:notification_id]
      @notification = Notification.find_by(id: params[:notification_id], recipient: current_user)
      @notification.mark_as_read! if @notification
    end
  end

  def set_post
    @post = Post.find_by(id: params[:id])
    redirect_to posts_url, alert: "The post you were viewing no longer exists." unless @post
  end

  def post_params
    params.require(:post).permit(:body, :user_id, :image)
  end
end
