class PhotoGallery < ApplicationRecord
  belongs_to :user
  belongs_to :thumbnail, class_name: 'Photo', foreign_key: 'thumbnail_id', optional: true
  has_many :photos

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { minimum: 3, maximum: 15 }
end
