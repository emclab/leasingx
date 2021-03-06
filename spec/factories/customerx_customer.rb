FactoryGirl.define do
  factory :customerx_customer, class: 'Customerx::Customer' do
    name "MyString"
    short_name "MyString"
    since_date "2013-01-12"
    contact_info "MyText"
    address "MyText"
    shipping_address "MyText"
    zone_id 1
    customer_status_category_id 1
    phone "1234"
    fax "fax2344"
    email "MyString@example.sina.com"
    sales_id 1
    active true
    last_updated_by_id 1
    quality_system_id 1
    employee_num "4"
    revenue "100,000"
    customer_eval "MyText"
    main_biz "MyText"
    customer_taste "A good guy"
    note "My note"
  end

end