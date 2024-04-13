class Photo < ApplicationRecord
  belongs_to :photo_gallery
  has_one_attached :original_image
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [250, 250]
  end
end
