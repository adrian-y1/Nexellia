class DropCommentLikesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :comment_likes
  end
end
