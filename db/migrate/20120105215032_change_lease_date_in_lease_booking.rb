class ChangeLeaseDateInLeaseBooking < ActiveRecord::Migration
  def up
    change_table :leasingx_lease_bookings do |t|
      t.change :lease_date, :date
    end
  end

  def down
    change_table :leasingx_lease_bookings do |t|
      t.change :lease_date, :datetime
    end    
  end
end
