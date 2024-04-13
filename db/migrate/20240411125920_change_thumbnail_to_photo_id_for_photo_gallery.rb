class ChangeThumbnailToPhotoIdForPhotoGallery < ActiveRecord::Migration[7.1]
  def change
    remove_column :photo_galleries, :thumbnail
    add_reference :photo_galleries, :thumbnail, foreign_key: { to_table: :photos }
  end
end
