FactoryGirl.define do

  factory :lease_booking, class: 'Leasingx::LeaseBooking' do
    customer_id            1
    sales_id               2
    lease_item_id          2
    start_time             '08:00'
    end_time               '09:00'
    cancelled              false
    completed              false
    input_by_id            3
    lease_date             Date.new(2012,1,11)
    leasee_name            'Jun Chen'  
    leasee_phone           '123456'
    lease_purpose          'for fun'
    discount               5
  end

end