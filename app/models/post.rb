class Post < ApplicationRecord
  validates :body, length: { maximum: 255 }

  belongs_to :user
end
