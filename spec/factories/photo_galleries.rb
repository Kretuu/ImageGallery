FactoryBot.define do
  factory :photo_gallery do
    user
    name { "Testing gallery" }
  end

  factory :other_photo_gallery, class: 'PhotoGallery' do
    user
    name { "Other gallery" }
  end
end

def photo_gallery_with_photos(user, photos_count: 5)
  FactoryBot.create(:photo_gallery, user: user) do |photo_gallery|
    FactoryBot.create_list(:photo, photos_count, photo_gallery: photo_gallery)
  end
end