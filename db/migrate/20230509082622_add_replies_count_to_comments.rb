class AddRepliesCountToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :replies_count, :integer, default: 0
  end
end
