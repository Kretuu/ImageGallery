class Photo < ApplicationRecord
  belongs_to :photo_gallery
  has_one_attached :original_image
  after_commit :process_images

  def image
    original_image.variant(crop: [x, y, w, h])
  end

  def thumbnail
    original_image.variant(crop: [x, y, w, h], resize_to_limit: [250, 250])
  end


  protected
  def process_images
    ImageProcessingJob.perform_later(self)
  end
end
