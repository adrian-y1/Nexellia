class CommentsController < ApplicationController
  before_action :find_commentable

  include ActionView::RecordIdentifier
  include ApplicationHelper

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent&.id # safe navigator to avoid NoMethodError on nil objects

    respond_to do |format|
      if @comment.save
        format.turbo_stream { flash.now[:notice] = "Comment was successfully created." }
        format.html { redirect_to posts_path, notice: "Comment was successfully created." }
      else
        format.turbo_stream { }
        format.html { render :new, status: :unprocessable_entity, alert: "Comment could not be created." }
      end
    end
  end

  def destroy
    @comment = Comment.includes(comments: [:comments, :likes, :parent]).find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Comment was successfully deleted." }
      format.html { redirect_to posts_path, notice: "Comment was successfully deleted." }
    end
  end

  def like
    @comment = Comment.find(params[:comment_id])
    current_user.like(@comment)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream
      end
    end
  end

  private

  def private_stream
    @comment = Comment.find(params[:comment_id])
    private_target = "#{dom_id(@comment)} private_likes"
    turbo_stream.replace(private_target, partial: "likes/comment_like_button", 
        locals: { comment: @comment, post: @comment.commentable, like_status: current_user.liked?(@comment) })
  end

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def find_commentable
    # @commentable references the commentable(post) a comment belongs to no matter the nesting level
    if params[:comment_id]
      @parent = Comment.find_by_id(params[:comment_id])
      @commentable = @parent.commentable
    elsif params[:post_id]
      @commentable = Post.find_by_id(params[:post_id])
    end
  end
end
