class AddIndexToPostLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :post_likes, [:liker_id, :liked_post_id], unique: true
  end
end
