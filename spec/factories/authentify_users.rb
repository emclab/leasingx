FactoryGirl.define do
  factory :authentify_user, class: 'Authentify::User' do
    name                  "Test User"
    login                 'testuser'
    email                 "test@test.com"
    password              "password1"
    password_confirmation {password}
    status                "active"
    last_updated_by_id    1
  end
end