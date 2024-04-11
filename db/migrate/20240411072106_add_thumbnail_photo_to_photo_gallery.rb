class AddThumbnailPhotoToPhotoGallery < ActiveRecord::Migration[7.1]
  def change
    add_column :photo_galleries, :thumbnail, :string
  end
end
