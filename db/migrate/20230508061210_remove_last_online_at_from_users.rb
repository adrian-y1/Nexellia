class RemoveLastOnlineAtFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :last_online_at
  end
end
