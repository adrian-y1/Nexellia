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
    broadcast_to_recipient_unread_notifications
    broadcast_to_recipient_all_notifications
    broadcast_notifications_count
  end

  after_update_commit do 
    broadcast_notifications_count
  end

  private 
  
  # Broadcasts the new notification to the user's unread_notifications which is displayed under the navbar
  def broadcast_to_recipient_unread_notifications
    stream_name = "unread_notifications_#{recipient.id}"
    broadcast_prepend_later_to stream_name, target: stream_name, partial: "notifications/unread_notification",
      locals: { unread_notification: self, unread: true}
  end

  # Broadcasts a prepend to the user's all_notifications drop menu list
  def broadcast_to_recipient_all_notifications
    stream_name = "all_notifications_#{recipient.id}"
    broadcast_prepend_later_to stream_name, target: stream_name, partial: "notifications/all_notifications_item",
      locals: { notification: self, unread: true }
  end

  # Broadcasts the unread notifications count for the recipient
  def broadcast_notifications_count
    stream_name = "user_#{recipient.id}_notifications_count"
    broadcast_replace_later_to stream_name, target: stream_name, partial: "notifications/notifications_count",
      locals: { unread_notifications: recipient.notifications.unread.newest_first.to_a, user: recipient } 
  end
end
