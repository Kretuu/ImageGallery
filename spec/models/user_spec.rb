require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#create" do
    it "does not save user if first name is empty" do
      user = User.new(email: "test@test.com", password: "testing", last_name: "Last name")
      expect(user.save).to be_falsey
    end

    it "does not save user if last name is empty" do
      user = User.new(email: "test@test.com", password: "testing", first_name: "First name")
      expect(user.save).to be_falsey
    end

    it "creates user" do
      user = User.new(email: "test@test.com", password: "testing", first_name: "First name", last_name: "Last name")
      expect(user.save).to be_truthy
    end
  end
end