class PostsController < ApplicationController
  def index
    @posts = Post.user_and_friends_posts(current_user)
  end
end
