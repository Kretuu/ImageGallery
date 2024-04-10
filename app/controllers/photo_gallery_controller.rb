class PhotoGalleryController < ApplicationController
  load_and_authorize_resource :photo_gallery
  def index

  end

  def new

  end

  def show
    # flash.now[:alert] = "Could not add a facilitator to the module."
  end
end
