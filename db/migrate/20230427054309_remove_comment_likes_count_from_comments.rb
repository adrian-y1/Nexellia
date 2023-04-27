class RemoveCommentLikesCountFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :comment_likes_count
  end
end
