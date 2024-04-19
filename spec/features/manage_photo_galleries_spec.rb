require 'rails_helper'

describe 'Photo galleries' do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:photo_gallery) { photo_gallery_with_photos(user) }
  let!(:other_photo_gallery) { FactoryBot.create(:other_photo_gallery, user: other_user) }


  context 'Not logged in' do
    specify 'I can see photo galleries on the main page' do
      visit '/'

      expect(page).to have_content 'Testing gallery'
      expect(page).to have_content 'Other gallery'
    end

    specify 'I can view gallery' do
      visit '/'

      find("a[href=\"/gallery/#{photo_gallery.id}\"]").click

      expect(page).to have_content photo_gallery.name
    end

    specify 'I cannot access edit gallery view' do
      visit "/gallery/#{photo_gallery.id}/edit"

      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end

  context 'Logged in' do
    before { login_as user }

    specify 'I can see photo galleries on the main page' do
      visit '/'

      expect(page).to have_content 'Testing gallery'
      expect(page).to have_content 'Other gallery'
    end

    specify 'I can see only my photo galleries on My Galleries page' do
      visit '/my_galleries'

      expect(page).to have_content 'Testing gallery'
      expect(page).not_to have_content 'Other gallery'
    end

    specify 'I can create a gallery' do
      visit '/'

      click_on 'Create album'
      fill_in 'Album title', with: 'New album'
      click_on 'Save'

      expect(page).to have_content 'New album'
      expect(page).to have_content 'Gallery was successfully created.'
    end

    specify 'I can delete my gallery', js: true do
      visit '/my_galleries'

      within("div[data-gallery-delete-path-value=\"/gallery/#{photo_gallery.id}\"]") do
        click_on 'Delete'
      end

      within("#confirmDeleteModal") do
        click_on 'Delete'
      end

      expect(page).to have_content 'Gallery was successfully deleted.'
    end

    specify 'I can view gallery' do
      visit '/'

      find("a[href=\"/gallery/#{photo_gallery.id}\"]").click

      expect(page).to have_content photo_gallery.name
    end

    specify 'I can edit gallery name' do
      visit "/gallery/#{photo_gallery.id}/edit"

      within("form[action=\"/gallery/#{photo_gallery.id}\"]") do
        find("input[type=\"text\"]").fill_in with: 'Changed title'
        click_on 'Save'
      end

      expect(page).to have_content 'Album title was updated successfully.'

      click_on 'Go back to gallery view'

      expect(page).to have_content 'Changed title'
    end

    specify 'I can delete photo' do
      visit "/gallery/#{photo_gallery.id}/edit"

      within("div[data-photo-path-value=\"/gallery/#{photo_gallery.id}/photo/#{photo_gallery.photos.first.id}\"]") do
        click_on 'Delete'
      end

      within('#confirmDeleteModal') do
        click_on 'Delete'
      end

      expect(page).to have_content 'Photo has been successfully deleted.'
    end

    specify 'I can set cover photo' do
      visit "/gallery/#{photo_gallery.id}/edit"

      click_on 'Set cover photo'

      within("form[action=\"/gallery/#{photo_gallery.id}/set_thumbnail?thumbnail_id=#{photo_gallery.photos.first.id}\"]") do
        find('button').click
      end

      expect(page).to have_content 'Cover photo was set successfully'
    end
  end
end