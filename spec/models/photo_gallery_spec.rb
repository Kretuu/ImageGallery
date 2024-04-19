require 'rails_helper'

RSpec.describe PhotoGallery, type: :model do
  let!(:user) { FactoryBot.create(:user) }

  describe "#create" do
    it "does not save gallery if name length is less than 3" do
      gallery = PhotoGallery.new(user: user, name: "sd")
      expect(gallery.save).to be_falsey
    end

    it "does not save gallery if name length is greater than 15" do
      gallery = PhotoGallery.new(user: user, name: "I am longer than 15 for sure")
      expect(gallery.save).to be_falsey
    end

    it "saves gallery if name is valid" do
      gallery = PhotoGallery.new(user: user, name: "Gallery name")
      expect(gallery.save).to be_truthy
    end
  end
end