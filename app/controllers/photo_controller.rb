class PhotoController < ApplicationController
  load_and_authorize_resource :photo_gallery
  load_and_authorize_resource :photo, through: :photo_gallery, except: [:create]

  def new

  end

  def create
    @photo = Photo.new(photo_gallery_id: params[:photo_gallery_id])
    authorize! :create, @photo

    if @photo.save && @photo.original_image.attach(params[:original_image])
      head 200
    else
      head 500
    end
  end

  def show
    respond_to do |format|
      format.json { render json: t.response }
    end
  end
end
