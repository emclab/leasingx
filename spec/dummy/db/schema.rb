# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130120225807) do

  create_table "authentify_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentify_sessions", ["session_id"], :name => "index_authentify_sessions_on_session_id"
  add_index "authentify_sessions", ["updated_at"], :name => "index_authentify_sessions_on_updated_at"

  create_table "authentify_sys_action_on_tables", :force => true do |t|
    t.string   "action"
    t.string   "table_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentify_sys_action_on_tables", ["action"], :name => "index_authentify_sys_action_on_tables_on_action"
  add_index "authentify_sys_action_on_tables", ["table_name"], :name => "index_authentify_sys_action_on_tables_on_table_name"

  create_table "authentify_sys_logs", :force => true do |t|
    t.datetime "log_date"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_ip"
    t.string   "action_logged"
  end

  create_table "authentify_sys_module_mappings", :force => true do |t|
    t.integer  "sys_module_id"
    t.integer  "sys_user_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_sys_modules", :force => true do |t|
    t.string   "module_name"
    t.string   "module_group_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_sys_user_groups", :force => true do |t|
    t.string   "user_group_name"
    t.string   "short_note"
    t.integer  "user_type_code"
    t.string   "user_type_desp"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "zone_id"
  end

  create_table "authentify_sys_user_rights", :force => true do |t|
    t.integer  "sys_action_on_table_id"
    t.integer  "sys_user_group_id"
    t.string   "matching_column_name"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "accessible_col"
  end

  add_index "authentify_sys_user_rights", ["accessible_col"], :name => "index_authentify_sys_user_rights_on_accessible_col"
  add_index "authentify_sys_user_rights", ["sys_action_on_table_id"], :name => "index_authentify_sys_user_rights_on_sys_action_on_table_id"
  add_index "authentify_sys_user_rights", ["sys_user_group_id"], :name => "index_authentify_sys_user_rights_on_sys_user_group_id"

  create_table "authentify_user_levels", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sys_user_group_id"
    t.integer  "manager_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "status",                 :default => "active"
    t.integer  "last_updated_by_id"
    t.integer  "customer_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "authentify_zones", :force => true do |t|
    t.string   "zone_name"
    t.string   "brief_note"
    t.boolean  "active",        :default => true
    t.integer  "ranking_order"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "customerx_customer_status_categories", :force => true do |t|
    t.string   "cate_name"
    t.string   "brief_note"
    t.boolean  "active",             :default => true
    t.integer  "ranking_order"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "customerx_customers", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.date     "since_date"
    t.text     "contact_info"
    t.text     "address"
    t.text     "shipping_address"
    t.integer  "zone_id"
    t.integer  "customer_status_category_id"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.integer  "sales_id"
    t.boolean  "active",                      :default => true
    t.integer  "last_updated_by_id"
    t.integer  "quality_system_id"
    t.string   "employee_num"
    t.string   "revenue"
    t.text     "customer_eval"
    t.text     "main_biz"
    t.text     "customer_taste"
    t.text     "note"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "web"
  end

  create_table "customerx_lead_logs", :force => true do |t|
    t.integer  "sales_lead_id"
    t.text     "log"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "customerx_quality_systems", :force => true do |t|
    t.string   "name"
    t.string   "brief_note"
    t.boolean  "active"
    t.integer  "last_updated_by_id"
    t.integer  "ranking_order"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "customerx_sales_leads", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "last_updated_by_id"
    t.integer  "provider_id"
    t.text     "lead_info"
    t.text     "contact_instruction"
    t.string   "lead_status"
    t.boolean  "sale_success"
    t.boolean  "close_lead"
    t.datetime "close_lead_date"
    t.integer  "close_lead_by_id"
    t.string   "lead_source"
    t.integer  "lead_quality"
    t.integer  "lead_accuracy"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "lead_eval"
  end

  create_table "leasingx_lease_bookings", :force => true do |t|
    t.integer  "lease_item_id"
    t.integer  "customer_id"
    t.integer  "sales_id"
    t.date     "lease_date"
    t.integer  "input_by_id"
    t.string   "start_time"
    t.string   "end_time"
    t.decimal  "total_hour",       :precision => 4,  :scale => 2, :default => 0.0
    t.boolean  "cancelled",                                       :default => false
    t.boolean  "completed",                                       :default => false
    t.string   "leasee_name"
    t.string   "leasee_phone"
    t.string   "lease_purpose"
    t.text     "note"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "discount",                                        :default => 0
    t.decimal  "charge_rate",      :precision => 8,  :scale => 2
    t.decimal  "item_hourly_rate", :precision => 10, :scale => 2
  end

  create_table "leasingx_lease_items", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "hourly_rate", :precision => 7, :scale => 2
    t.boolean  "active",                                    :default => true
    t.integer  "input_by_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "short_name"
  end

  create_table "leasingx_lease_logs", :force => true do |t|
    t.string   "subject"
    t.text     "log"
    t.decimal  "total_hour",       :precision => 3, :scale => 1
    t.integer  "input_by_id"
    t.integer  "lease_booking_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

end
