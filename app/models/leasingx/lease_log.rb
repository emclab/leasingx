module Leasingx

    class LeaseLog < ActiveRecord::Base
      belongs_to :lease_booking
      belongs_to :input_by, :class_name => 'Authentify::User'
       
      attr_accessible :subject, :log, :total_hour, :lease_booking_id, :input_by_id, :as => :roles_new
      
      validates :subject, :presence => true
      validates :log, :presence => true
     
    end

end