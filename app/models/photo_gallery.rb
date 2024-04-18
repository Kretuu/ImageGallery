class PhotoGallery < ApplicationRecord
  belongs_to :user
  belongs_to :thumbnail, class_name: 'Photo', foreign_key: 'thumbnail_id', optional: true
  has_many :photos, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 15 }
end
