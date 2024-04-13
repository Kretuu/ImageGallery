class PhotoGallery < ApplicationRecord
  belongs_to :user
  belongs_to :thumbnail, class_name: 'Photo', foreign_key: 'thumbnail_id', optional: true
  has_many_attached :photos do |attachable|
    attachable.variant :thumb, resize_to_limit: [250, 250]
  end

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { minimum: 3, maximum: 15 }
end
