class PhotoController < ApplicationController
  load_and_authorize_resource :photo_gallery
  load_and_authorize_resource :photo, through: :photo_gallery

  def new

  end

  def show

  end
end
