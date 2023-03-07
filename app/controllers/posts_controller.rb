class PostsController < ApplicationController
  def index
    @posts = Post.user_and_friends_posts(current_user).includes(:comments)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_parmas)

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity, alert: "Post could not be created." }
      end
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update(post_parmas)
        format.turbo_stream
      else
        format.html { render :edit, status: :see_other, alert: "Post could not be updated." }
      end
    end
  end

  private

  def post_parmas
    params.require(:post).permit(:body, :user_id)
  end
end
