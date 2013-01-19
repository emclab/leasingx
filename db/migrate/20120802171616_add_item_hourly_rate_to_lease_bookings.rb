class AddItemHourlyRateToLeaseBookings < ActiveRecord::Migration
  def change
    add_column :leasingx_lease_bookings, :item_hourly_rate, :decimal, :precision => 10, :scale => 2
  end
end
