class CreateLeaseItems < ActiveRecord::Migration
  def change
    create_table :leasingx_lease_items do |t|
      t.string :name
      t.string :description
      t.decimal :hourly_rate, :precision => 7, :scale => 2
      t.boolean :active, :default => true
      t.integer :discount, :default => 0
      t.integer :input_by_id

      t.timestamps
    end
  end
end
