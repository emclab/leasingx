# This migration comes from customerx (originally 20110921051742)
class Remove2EngColsFromCustomers < ActiveRecord::Migration
  def up
    remove_column :customerx_customers, :safety_eng_id
    remove_column :customerx_customers, :test_eng_id
  end

  def down
    add_column :customerx_customers, :safety_eng_id, :integer
    add_column :customerx_customers, :test_eng_id, :integer    
  end
end
