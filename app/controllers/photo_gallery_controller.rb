class PhotoGalleryController < ApplicationController
  load_and_authorize_resource :photo_gallery
  def index

  end
end
