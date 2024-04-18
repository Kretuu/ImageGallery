class PhotoController < ApplicationController
  load_and_authorize_resource :photo_gallery
  load_and_authorize_resource :photo, through: :photo_gallery, except: [:create]


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
    render json: {
      image: url_for(@photo.image)
    }
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

  def destroy
    if @photo.destroy
      redirect_to edit_photo_gallery_path(@photo_gallery),
                  notice: "Photo has been successfully deleted."
    else
      redirect_to edit_photo_gallery_path(@photo_gallery),
                  alert: "Something went wrong. Could not delete the photo."
    end

  end

  private
  def update_params
    if params[:photo][:id]
      params[:photo][:photo_gallery_id] = params[:photo][:id]
    end
    params.require(:photo).permit(:photo_gallery_id, :x, :y, :w, :h)
  end
end
