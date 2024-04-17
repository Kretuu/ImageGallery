class PhotoController < ApplicationController
  load_and_authorize_resource :photo_gallery
  load_and_authorize_resource :photo, through: :photo_gallery, except: [:create]

  def new

  end

  def create
    @photo = Photo.new(photo_gallery_id: params[:photo_gallery_id])
    authorize! :create, @photo

    if @photo.save && @photo.original_image.attach(params[:original_image])
      render json: {
        path: photo_gallery_photo_path(@photo_gallery, @photo)
      }
    else
      head 500
    end
  end

  def update
    if @photo.update(update_params)
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

  def edit
    render json: {
      original_image: url_for(@photo.original_image),
      x: @photo.x,
      y: @photo.y,
      w: @photo.w,
      h: @photo.h
    }
  end

  private
  def update_params
    if params[:photo][:id]
      params[:photo][:photo_gallery_id] = params[:photo][:id]
    end
    params.require(:photo).permit(:photo_gallery_id, :x, :y, :w, :h)
  end
end
