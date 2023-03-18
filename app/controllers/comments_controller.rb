class CommentsController < ApplicationController
  
  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream { flash.now[:notice] = "Comment was successfully created." }
        format.html { redirect_to posts_path, notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity, alert: "Comment could not be created." }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :post_id)
  end
end
