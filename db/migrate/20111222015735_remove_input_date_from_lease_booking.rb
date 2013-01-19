class RemoveInputDateFromLeaseBooking < ActiveRecord::Migration
  def up
    remove_column :leasingx_lease_bookings, :input_date
  end

  def down
    add_column :leasingx_lease_bookings, :input_date, :datetime
  end
end


