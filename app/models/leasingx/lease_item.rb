module Leasingx

  class LeaseItem < ActiveRecord::Base
    has_many :lease_bookings
    belongs_to :input_by, :class_name => 'Authentify::User'
    attr_accessor :keyword, :min_hourly_rate, :max_hourly_rate
    attr_accessible :keyword, :min_hourly_rate, :max_hourly_rate, :as => :roles_search
    attr_accessible :name, :description, :hourly_rate, :short_name, :active, :input_by_id, :as => :roles_new
    attr_accessible :name, :description, :hourly_rate, :active, :short_name, :as => :roles_update
    
    validates :name, :presence => true, :uniqueness => { :scope => :active, :case_sensitive => false }, :if => "active"
    validates :description, :presence => true
    validates :hourly_rate, :presence => true
    validates_numericality_of :hourly_rate, :greater_than => 0 
    
    scope :active_lease_item, where(:active => true) 
    scope :inactive_lease_item, where(:active => false)  
    
    def find_lease_items
      lease_items = LeaseItem.order(:name)
      lease_items = lease_items.where("name like ?", "%#{keyword}%") if keyword.present?
      lease_items = lease_items.where("hourly_rate >= ?", min_hourly_rate) if min_hourly_rate.present?
      lease_items = lease_items.where("hourly_rate <= ?", max_hourly_rate) if max_hourly_rate.present?
      lease_items
    end
    
    private
      
  end

end