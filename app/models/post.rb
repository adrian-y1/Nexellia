# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  likes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
class Post < ApplicationRecord
  include ActionView::RecordIdentifier
  
  belongs_to :user, counter_cache: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_one_attached :image
  
  validates :body, presence: true, length: { maximum: 255, message: "Post description length exceeded." }
  validate :image_type

  # Added eager loading for user, profile, picture_attachment and blob to avoid N+1 queries problem
  scope :user_and_friends_posts, -> (user) { includes(user: { profile: { picture_attachment: :blob } })
                                             .where(user_id: [user.id] + user.friends.pluck(:id)).order(id: :desc) }

  after_create_commit -> do 
    broadcast_prepend_later_to [self.user.id, "posts"], partial: "posts/post_interactions", locals: { post: self, user: Current.user }, target: "posts" 
  end

  after_update_commit -> do 
    broadcast_update_later_to [self.user.id, "posts"], partial: "posts/post_body", locals: { post: self }, target: "#{dom_id(self)}_index"
    broadcast_update_later_to self, partial: "posts/show_page_post_body", locals: { post: self } , target: "#{dom_id(self)}_show"
  end
  
  after_destroy_commit -> do 
    broadcast_remove_to [self.user.id, "posts"], target: "post-interactions-#{self.id}"
    broadcast_remove_to self, target: "show-page-post-interactions-#{self.id}"
    broadcast_prepend_to self, target: "post_deleted", partial: "posts/post_deleted"
  end

  private

  def image_type
    return unless image.attached?
    
    acceptable_types = %w[image/jpeg image/jpg image/png image/gif]
    if !image.content_type.in?(acceptable_types)
      errors.add(:image, "needs to be a JPEG, JPG, PNG or GIF")
    end
  end
end
