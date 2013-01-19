class CreateLeaseLogs < ActiveRecord::Migration
  def change
    create_table :leasingx_lease_logs do |t|
      t.string :subject
      t.text :log
      t.decimal :total_hour, :precision => 3, :scale => 1
      t.integer :input_by_id
      t.integer :lease_booking_id

      t.timestamps
    end
  end
end
