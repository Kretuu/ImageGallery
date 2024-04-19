FactoryBot.define do
  factory :photo do
    photo_gallery

    after(:build) do |photo|
      photo.image.attach(
        io: File.open('spec/fixtures/files/test_image1.png'),
        filename: '1.png',
        content_type: 'image/png'
      )
    end
  end
end