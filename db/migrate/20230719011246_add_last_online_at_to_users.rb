class AddLastOnlineAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_online_at, :datetime, default: nil
  end
end
