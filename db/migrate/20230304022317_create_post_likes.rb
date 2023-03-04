class CreatePostLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :post_likes do |t|
      t.integer :liker_id
      t.integer :liked_post_id

      t.timestamps
    end
  end
end
