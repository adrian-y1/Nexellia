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
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(@post, partial: "posts/post", locals: { post: @post, user: Current.user } )}
        format.html { redirect_to posts_path, notice: "Post was successfully created." }
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
        format.turbo_stream { render turbo_stream: turbo_stream.update(@post, partial: "posts/post", locals: { post: @post, user: Current.user }) }
        format.html { redirect_to posts_path, notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :see_other, alert: "Post could not be updated." }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
      format.html { redirect_to posts_url }
    end
  end

  private

  def post_parmas
    params.require(:post).permit(:body, :user_id)
  end
end
