class RemoveDiscountFromLeaseItem < ActiveRecord::Migration
  def up
    remove_column :leasingx_lease_items, :discount
  end

  def down
    add_column :leasingx_lease_items, :discount, :integer
  end
end
