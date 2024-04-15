class PhotoController < ApplicationController
  load_and_authorize_resource :photo_gallery
  load_and_authorize_resource :photo, through: :photo_gallery

  def new

  end

  def create

  end

  def show
    respond_to do |format|
      format.json { render json: t.response }
    end
  end

  private
  def create_params
    params.require(:photo).permit(:original_image)
  end
end
