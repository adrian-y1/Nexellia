class RemoveRepliesCountFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :replies_count
  end
end
