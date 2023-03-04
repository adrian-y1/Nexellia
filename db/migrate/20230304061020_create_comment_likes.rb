class CreateCommentLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_likes do |t|
      t.integer :liker_id
      t.integer :liked_comment_id

      t.timestamps
    end
  end
end
