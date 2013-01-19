class CreateLeaseBookings < ActiveRecord::Migration
  def change
    create_table :leasingx_lease_bookings do |t|
      t.integer :lease_item_id
      t.integer :customer_id
      t.integer :sales_id
      t.date :lease_date
      t.datetime :input_date
      t.integer :input_by_id
      t.string :start_time
      t.string :end_time
      t.decimal :total_hour, :default=>0.00, :precision => 4, :scale => 2
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.string :leasee_name
      t.string :leasee_phone
      t.string :lease_purpose
      t.text :note

      t.timestamps
    end
  end
end
