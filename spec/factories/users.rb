FactoryBot.define do
  factory :user, class: 'User' do
    email { "testing" + rand(10**9..10**10).to_s + "@test.com" }
    password { "P4$$word" }
    first_name { "Testing" }
    last_name { "Name" }
  end

  factory :other_user, class: 'User' do
    email { "testing" + rand(10**9..10**10).to_s + "@test.com" }
    password { "P4$$word" }
    first_name { "Testing2" }
    last_name { "Name2" }
  end
end