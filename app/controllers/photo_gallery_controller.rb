class PhotoGalleryController < ApplicationController
  before_action :set_gallery, only: [:set_thumbnail]
  load_and_authorize_resource :photo_gallery
  def index

  end

  def new

  end

  def edit
    @set_thumbnail = params[:set_thumbnail]
  end

  def update
    if @photo_gallery.update(photo_gallery_params)
      redirect_to edit_photo_gallery_path(@photo_gallery), notice: "Album title was updated successfully."
    else
      flash.now[:alert] = "Something went wrong. Could not update album title."
      render :edit, status: :unprocessable_entity
    end
  end

  def set_thumbnail
    requested_photo = Photo.find(params[:thumbnail_id])
    if requested_photo && @photo_gallery.update(thumbnail: requested_photo)
      redirect_to :edit, notice: "Thumbnail was set successfully"
    else
      redirect_to :edit, alert: "Something went wrong"
    end
  end

  def show
    # flash.now[:alert] = "Could not add a facilitator to the module."
  end

  private
  def set_gallery
    @photo_gallery = PhotoGallery.find(params[:photo_gallery_id])
    authorize! :manage, @photo_gallery
  end

  def photo_gallery_params
    params.require(:photo_gallery).permit(:name)
  end
end
