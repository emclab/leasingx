class AddColDiscountToLeaseBooking < ActiveRecord::Migration
  def change
    add_column :leasingx_lease_bookings, :discount, :tinyint, :default => 0
  end
end
