class DropPostLikesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :post_likes, if_exists: true
  end
end
