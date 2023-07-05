class SearchController < ApplicationController
  def index
    if params[:q].present?
      @users = User.by_first_last_name(params[:q]).load_profiles
    else
      redirect_to posts_path
    end
  end
end
