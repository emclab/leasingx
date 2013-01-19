FactoryGirl.define do
  factory :lease_item, class: 'Leasingx::LeaseItem' do
    name                  "test lease item"
    description           "one 3m test chamber"
    hourly_rate           1200.50
    active                true
    input_by_id           4
  end

end