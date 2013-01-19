class AddChargeRateToLeaseBookings < ActiveRecord::Migration
  def change
    add_column :leasingx_lease_bookings, :charge_rate, :decimal, :precision => 8, :scale => 2
  end
end
