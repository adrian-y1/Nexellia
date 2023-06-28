class AddIsClosedToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :is_closed, :boolean, default: false
  end
end
