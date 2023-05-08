class AddLastOnlineAtAndStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :status, :string, default: "offline", null: false
    add_column :users, :last_online_at, :datetime
  end
end
