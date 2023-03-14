class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  def index
    @posts = Post.user_and_friends_posts(current_user).includes(:comments)
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
        format.turbo_stream do 
          redirect_to redirect_context
          flash.now[:notice] = "Post was successfully updated." 
        end
        format.html { redirect_to posts_path, notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :see_other, alert: "Post could not be updated." }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.turbo_stream { redirect_to posts_url, status: :see_other, notice: "Post was successfully deleted." }
      format.html { redirect_to posts_url, notice: "Post was successfully deleted." }
    end
  end

  private

  def redirect_context
    request.referrer.include?("#{@post.id}") ? @post : posts_url
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :user_id)
  end
end
