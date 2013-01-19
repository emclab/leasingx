FactoryGirl.define do
  factory :lease_log, class: 'Leasingx::LeaseLog' do
    subject                'update'
    log                    'customer finished the test today'
    total_hour             1.5
    input_by_id            2
  end

end