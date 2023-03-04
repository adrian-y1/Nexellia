class AddCommentLikesCountToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comment_likes_count, :integer, default: 0
  end
end
