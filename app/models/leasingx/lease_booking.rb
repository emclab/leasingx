# encoding: utf-8

module Leasingx
  
    class LeaseBooking < ActiveRecord::Base
      
      belongs_to :customer, :class_name => 'Customerx::Customer'
      belongs_to :lease_item
      has_many :lease_logs, :dependent => :destroy
      
      belongs_to :sales, :class_name => 'Authentify::User'
      belongs_to :last_updated_by, :class_name => 'Authentify::User'
     
      
      attr_accessible :customer_id, :lease_item_id, :lease_date, :discount, :start_time, :end_time, :total_hour, 
                      :leasee_name, :leasee_phone, :lease_purpose, :note, :charge_rate, :sales_id, :cancelled,
                      :completed, :input_by_id,
                      :as => :roles_new
      attr_accessible :lease_date, :discount, :start_time, :end_time, :total_hour, :lease_purpose, 
                      :leasee_name, :leasee_phone, :note, :completed, :cancelled, :charge_rate,
                      :as => :roles_update 
      
                      
      attr_accessor :open_slot, :slot_taken
      attr_accessor :lease_item_id_search, :earliest_lease_date_search, :latest_lease_date_search, :customer_id_search, :sales_id_search, :time_frame
      
      attr_accessible :lease_item_id_search, :earliest_lease_date_search, :latest_lease_date_search, :customer_id_search, :sales_id_search, :time_frame,
                      :as => :roles_search       
                                
      validates_numericality_of :customer_id, :lease_item_id, :sales_id, :greater_than => 0
      validates :start_time, :end_time, :lease_date, :leasee_name, :leasee_phone, :presence => true
      validates_inclusion_of :discount, :in => 0..100
      
      scope :valid_booking, where(:cancelled => false) 
      scope :completed_booking, where(:competed => true)
      
      def desc
        self.lease_item.name + "--" +
        self.lease_date.strftime("%Y-%m-%d") + "--" + 
        self.start_time + "--" +
        self.end_time + "--" +
        self.total_hour.to_s + "--" +
        self.charge_rate.to_s 
        
      end
      
      def find_lease_bookings
        lease_bookings = LeaseBooking.where("lease_date > ?", 6.years.ago).order("lease_date DESC")
        lease_bookings = lease_bookings.where("lease_date >= ?", earliest_lease_date_search) if earliest_lease_date_search.present?
        lease_bookings = lease_bookings.where("lease_date <= ?", latest_lease_date_search) if latest_lease_date_search.present?
        lease_bookings = lease_bookings.where("lease_item_id = ?", lease_item_id_search) if lease_item_id_search.present?
        lease_bookings = lease_bookings.where("sales_id = ?", sales_id_search) if sales_id_search.present?
        lease_bookings = lease_bookings.where("customer_id = ?", customer_id_search) if customer_id_search.present?
        lease_bookings
      end
      
      protected
     
     
    end
end