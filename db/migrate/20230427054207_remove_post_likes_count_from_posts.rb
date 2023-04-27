class RemovePostLikesCountFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :post_likes_count
  end
end
