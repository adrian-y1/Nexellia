class RemoveCommentAndPostLikesCountFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :post_likes_count
    remove_column :users, :comment_likes_count
  end
end
