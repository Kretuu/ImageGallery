class PhotoGalleryController < ApplicationController
  before_action :set_gallery, only: [:set_thumbnail]
  load_and_authorize_resource :photo_gallery
  def index
  end

  def my_galleries
    @photo_galleries = PhotoGallery.accessible_by(current_ability, :manage)
    @my_gallery = true
    render :index
  end

  def new
  end

  def create
    if @photo_gallery.save
      redirect_to @photo_gallery, notice: "Gallery was successfully created. You can now add some photos and set cover photo. You can only choose cover photo from images uploaded to the album."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @photo_gallery.update(thumbnail: nil) && @photo_gallery.destroy
      redirect_to my_galleries_path, notice: "Gallery was successfully deleted."
    else
      redirect_to my_galleries_path, alert: "Something went wrong. Could not delete the gallery."
    end
  end

  def edit
    @set_thumbnail = params[:set_thumbnail]
    if @set_thumbnail
      flash.now[:notice] = "Click on the photo in gallery to set the cover photo."
    end
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
      redirect_to edit_photo_gallery_path(@photo_gallery, set_thumbnail: 1), notice: "Thumbnail was set successfully"
    else
      redirect_to edit_photo_gallery_path(@photo_gallery, set_thumbnail: 1), alert: "Something went wrong"
    end
  end

  def show
    if params[:notice]
      flash.now[:notice] = params[:notice]
    end

    if params[:alert]
      flash.now[:alert] = params[:alert]
    end
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
