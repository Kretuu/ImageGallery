class ImageProcessingJob < ApplicationJob
  queue_as :default

  def perform(photo)
    return unless photo.original_image.representable?

    unless photo.x.nil? || photo.y.nil? || photo.w.nil? || photo.h.nil?
      photo.original_image.variant(crop: [photo.x, photo.y, photo.w, photo.h]).processed
      photo.original_image.variant(crop: [photo.x, photo.y, photo.w, photo.h], resize_to_limit: [250, 250]).processed
    end
  end
end
