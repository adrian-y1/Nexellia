# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_read_at    (read_at)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#
class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit do 
    broadcast_to_new_notifications
    broadcast_to_dropdown_notifications
    broadcast_to_index_notifications
    broadcast_notifications_count_async
  end

  after_update_commit do 
    broadcast_notifications_count_async
  end

  after_destroy_commit do
    broadcast_remove_new_notification
    broadcast_remove_dropdown_notification
    broadcast_notifications_count_sync
    broadcast_remove_index_notification
  end

  private 
  
  # Broadcasts the new notification to the user's new_notifications stream which is displayed under the navbar
  def broadcast_to_new_notifications
    stream_name = "new_notifications_#{recipient.id}"
    broadcast_prepend_later_to stream_name, target: stream_name, partial: "notifications/new_notification",
      locals: { unread_notification: self, unread: true, user: recipient }
  end

  # Broadcasts a prepend to the user's dropdown_notifications stream
  def broadcast_to_dropdown_notifications
    stream_name = "dropdown_notifications_#{recipient.id}"
    broadcast_prepend_later_to stream_name, target: stream_name, partial: "notifications/dropdown_notification",
      locals: { notification: self, unread: true }
  end

  # Broadcasts a prepend to the user's index-notifications stream
  def broadcast_to_index_notifications
    stream_name = "index-notifications_#{recipient.id}"
    broadcast_prepend_later_to stream_name, target: stream_name, partial: "notifications/dropdown_notification",
      locals: { notification: self, unread: true }
  end

  # Broadcasts the unread notifications count for the recipient (Asynchronously)
  def broadcast_notifications_count_async
    stream_name = "user_#{recipient.id}_notifications_count"
    broadcast_replace_later_to stream_name, target: stream_name, partial: "notifications/notifications_count",
      locals: { unread_notifications: recipient.notifications.unread.newest_first.to_a, user: recipient } 
  end

  # Broadcasts the unread notifications count for the recipient (Synchronously)
  def broadcast_notifications_count_sync
    stream_name = "user_#{recipient.id}_notifications_count"
    broadcast_replace_to stream_name, target: stream_name, partial: "notifications/notifications_count",
      locals: { unread_notifications: recipient.notifications.unread.newest_first.to_a, user: recipient } 
  end

  # Broadcasts a remove action to the specified notification to the new_notifications stream
  def broadcast_remove_new_notification
    broadcast_remove_to "new_notifications_#{recipient.id}", target: "new_notification_#{recipient.id}_#{id}"
  end

  # Broadcasts a remove action to the specified notification to the dropdown_notifications stream
  def broadcast_remove_dropdown_notification
    broadcast_remove_to "dropdown_notifications_#{recipient.id}", target: "dropdown_notification_#{recipient.id}_#{id}"
  end

  # Broadcasts a remove action to the specified notification to the index-notifications stream
  def broadcast_remove_index_notification
    broadcast_remove_to "index-notifications_#{recipient.id}", target: "dropdown_notification_#{recipient.id}_#{id}"
  end
end
