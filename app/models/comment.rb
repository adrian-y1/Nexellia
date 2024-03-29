# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string
#  likes_count      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint
#  parent_id        :integer
#  user_id          :integer
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  include NotificationCreatable
  include NotificationDestroyable
  
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  
  has_noticed_notifications model_name: 'Notification'
  
  validates :body, presence: true, length: { maximum: 255, message: "Comment length exceeded." }
  
  scope :load_user_and_profile, -> { includes(user: { profile: { picture_attachment: :blob } }) }
  scope :load_comments, -> { includes(comments: [:comments, :likes, :parent]) }
  
  after_create_commit -> do
    # Broadcast append to this comment's parent if it exists, else append to the commentable(post)
    broadcast_append_later_to [commentable, "comments"], target: "#{dom_id(parent || commentable)}_comments", partial: "comments/comment_replies", 
      locals: { comment: self, user: Current.user }
    broadcast_comments_count_async
  end
  
  after_destroy_commit -> do
    broadcast_remove_to [commentable, "comments"]
    broadcast_remove_to [self, "comments"], target: "#{dom_id(self)}_replies"
    broadcast_comments_count_sync
  end
  
  private

  # Synchronously broadcasts comments count for both posts#index and posts#show contexts
  def broadcast_comments_count_sync
    return unless commentable

    [:index, :show].each do |page|
      broadcast_replace_to [commentable, "comments"], target: "#{dom_id(commentable)}_comments_count_#{page}", partial: "comments/comment_count", 
        locals: { post: commentable, page: page }
    end
  end

  # Asynchronously broadcasts comments count for both posts#index and posts#show contexts
  def broadcast_comments_count_async
    [:index, :show].each do |page|
      broadcast_replace_later_to [commentable, "comments"], target: "#{dom_id(commentable)}_comments_count_#{page}", partial: "comments/comment_count", 
        locals: { post: commentable, page: page }
    end
  end
end
