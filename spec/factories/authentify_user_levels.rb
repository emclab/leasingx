FactoryGirl.define do
  factory :authentify_user_level, class: 'Authentify::UserLevel' do
    sys_user_group_id   1
    user_id              1
  end
end