class Photo < ApplicationRecord
  belongs_to :photo_gallery
  has_one_attached :original_image

  after_commit :process_images
  before_destroy :remove_thumbnail_references

  def image
    if !(x.nil? || y.nil? || w.nil? || h.nil?)
      original_image.variant(crop: [x, y, w, h])
    else
      original_image
    end
  end

  def thumbnail
    if !(x.nil? || y.nil? || w.nil? || h.nil?)
      original_image.variant(crop: [x, y, w, h], resize_to_limit: [250, 250])
    else
      original_image.variant(resize_to_limit: [250, 250])
    end
  end


  protected
  def process_images
    ImageProcessingJob.perform_later(self)
  end

  def remove_thumbnail_references
    PhotoGallery.where(thumbnail: self).each do |gallery|
      gallery.update(thumbnail: nil)
    end
  end
end
