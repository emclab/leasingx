# This migration comes from customerx (originally 20121023011918)
class AddCustomAttributesToCustomers < ActiveRecord::Migration
  def change
    add_column :customerx_customers, :custom_attributes, :text
  end
end
