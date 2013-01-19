# This migration comes from customerx (originally 20110909222323)
class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customerx_customers do |t|
      t.string :name
      t.string :short_name
      t.string :contact
      t.string :address
      t.string :country
      t.string :phone
      t.string :fax
      t.string :email
      t.string :cell
      t.integer :sales_id
      t.integer :test_eng_id
      t.integer :safety_eng_id
      t.string :web
      t.integer :category1_id
      t.integer :category2_id
      t.boolean :active, :default => true
      t.string :biz_status
      t.integer :last_updated_by_id
      t.string :quality_system
      t.string :employee_num
      t.string :revenue
      t.text :note
      t.integer :user_id

      t.timestamps
    end
  end
end
