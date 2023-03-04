class RemoveFriendsCountFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :friends_count, :integer
  end
end
