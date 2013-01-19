FactoryGirl.define do
  factory :customerx_customer, class: 'Customerx::Customer' do
    name                    "test customer"
    short_name              "test"
    email                   "t@acom.com"
    phone                   "12345678"
    cell                    "1234567890"
    active                  true
    category1_id            2
    sales_id                1
    address                 "1276 S. Highland Ave, Lombard, IL 67034"
    contact                 "Jun C"
    biz_status              1
    #biz                'blablabla'
  end

end