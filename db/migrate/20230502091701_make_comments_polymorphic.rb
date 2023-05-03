class MakeCommentsPolymorphic < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :commentable, polymorphic: true
    add_column :comments, :parent_id, :integer, null: true
    reversible do |dir|
      dir.up { Comment.update_all("commentable_id = post_id, commentable_type = 'Post'") }
      dir.down { Comment.update_all("post_id = commentable_id") }
    end

    remove_column :comments, :post_id, :integer
  end
end
