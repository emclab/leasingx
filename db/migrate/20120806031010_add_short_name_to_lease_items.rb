class AddShortNameToLeaseItems < ActiveRecord::Migration
  def change
    add_column :leasingx_lease_items, :short_name, :string
  end
end
