require 'rails_helper'

describe 'My user account' do
  let!(:user) { FactoryBot.create(:user) }

  before { login_as user }

  describe "Edit my account details" do
    it "Change first name and last name" do
      visit '/users/edit'

      fill_in 'First name', with: 'Jakub'
      fill_in 'Last name', with: 'Kreczetowski'
      fill_in 'Current password', with: 'P4$$word'

      click_on 'Save'

      expect(page).to have_content 'Your account has been updated successfully.'
    end
  end
end