# encoding: utf-8
require 'spec_helper'

module Leasingx

    describe LeaseBookingsController do
    
      before(:each) do
        #the following recognizes that there is a before filter without execution of it.
        controller.should_receive(:require_signin)
        controller.should_receive(:require_employee)
        #controller.should_receive(:session_timeout)
      end
        
      render_views
      
      describe "'index'" do
        it "should be successful" do
          zone = FactoryGirl.create(:authentify_zone)
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head', :zone_id => zone.id)
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          li = FactoryGirl.create(:lease_item)
          cust = FactoryGirl.create(:customerx_customer)
          lb = FactoryGirl.create(:lease_booking, :lease_item_id => li.id, :customer_id => cust.id, :sales_id => u.id)
          get 'index', {:use_route => :leasingx}
          response.should be_success
        end
      end
    
      describe "'new'" do
        it "should be successful for sales" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          get 'new' ,  {:use_route => :leasingx}
          response.should be_success
        end
        
        it "should be successful for corp head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          get 'new', {:use_route => :leasingx}
          response.should be_success
        end
        
        it "should be success for ceo" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'ceo')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          get 'new', {:use_route => :leasingx}
          response.should be_success
        end
        
        it "should reject for those without rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          get 'new', {:use_route => :leasingx}
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无权限输入出租Booking！")
        end
      end
    
      describe "'create'" do
        it "should be success for sales member" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          cust = FactoryGirl.create(:customerx_customer)
          item = FactoryGirl.create(:lease_item)
          booking = FactoryGirl.attributes_for(:lease_booking, :discount => 5, :lease_item_id => item.id, :customer_id => cust.id)
          post 'create', {:use_route => :leasingx, :lease_booking => booking }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Booking已保存！")
        end
        
        it "should be sucess by increasing by 1 record for sales dept head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          cust = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.attributes_for(:lease_booking, :lease_item_id => item.id, :customer_id => cust.id)
          lambda do
            post 'create', {:use_route => :leasingx, :lease_booking => booking }
          end.should change(LeaseBooking, :count).by(1)  
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Booking已保存！")
        end
        
        it "should reject for those without rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.attributes_for(:lease_booking)
          lambda do
            post 'create', {:use_route => :leasingx, :lease_booking => booking }
          end.should change(LeaseBooking, :count).by(0)
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无权限输入出租Booking！")     
        end
        
      end
    
      describe "'edit'" do
        it "should be successful for booking owner" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking, :sales_id => u.id)
          get 'edit', {:use_route => :leasingx, :id => booking.id }
          response.should be_success
        end
      end
    
      describe "'update'" do
        it "should be successful for booking owner" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id)
          get 'update', {:use_route => :leasingx, :id => booking.id, :lease_booking => {:start_time => "02:30"} }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Booking更改已保存!")
        end
        
        it "should be successful for corp head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id)
          get 'update', {:use_route => :leasingx, :id => booking.id, :lease_booking => {:end_time => "23:00"} }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Booking更改已保存!")      
        end
        
        it "should reject those without rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          session[:sales] = false
          get 'update', {:use_route => :leasingx, :id => booking.id, :lease_booking => {:discount => 1 }  }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无更改Booking权限！")
        end
        
      end
      
      describe "destroy'" do
        it "should be successful dept head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'destroy', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          get 'destroy',{:use_route => :leasingx,  :id => booking.id   }
          response.should redirect_to URI.escape("/view_handler?index=0msg=Booking已删除")
        end
        
        it "should be rejected for those without right" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          booking = FactoryGirl.create(:lease_booking)
          get 'destroy', {:use_route => :leasingx, :id => booking.id     }
          response.should redirect_to URI.escape("/view_handler?index=0msg=无删除权限")
        end
      end
    
      describe "'show'" do
    
        it "should grant view for the owner of the booking" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show', {:use_route => :leasingx, :id => booking.id }
          response.should be_success
        end
        
        it "should grant view for reporter" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'reporter')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show', {:use_route => :leasingx, :id => booking.id }
          response.should be_success
        end
            
        it "should grant view for corp head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show',  {:use_route => :leasingx, :id => booking.id  }
          response.should be_success
        end
        
        it "should grant view for ceo" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'ceo')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show', {:use_route => :leasingx, :id => booking.id }
          response.should be_success     
        end
        
        it "should grant view for eng member" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show', {:use_route => :leasingx, :id => booking.id }
          response.should be_success
        end
        
        it "should grant view for acct member" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'acct')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          customer = FactoryGirl.create(:customerx_customer)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => item.id, :customer_id => customer.id, :sales_id => u.id, :input_by_id => nil)
          get 'show', {:use_route => :leasingx,  :id => booking.id }
          response.should be_success
        end    
            
        it "should reject showing for those without rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          get 'show', {:use_route => :leasingx, :id => booking.id }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无权限查看出租Booking")
        end
      end
      
      describe "seach result" do
        it "should do search" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'acct')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'search_results', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          cust = FactoryGirl.create(:customerx_customer)
          lt = FactoryGirl.create(:lease_item)
          booking = FactoryGirl.create(:lease_booking, :lease_item_id => lt.id, :sales_id => u.id, :customer_id => cust.id)
          put 'search_results', {:use_route => :leasingx, :lease_booking => {:earliest_lease_date_search => '2012-01-01', :latest_lease_date_search => '2012-02-01'} }
          response.should be_success
        end
      end
      
      describe "stats results" do
        it "should allow sales dept head to pull stats" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'stats_results', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          10.times { FactoryGirl.create(:lease_booking) }
          put 'stats_results',  {:use_route => :leasingx, :lease_booking => {:time_frame => '周'}  }
          response.should be_success
        end
        
        it "should allow sales dept head to pull stats" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'stats_results', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          10.times { FactoryGirl.create(:lease_booking) }
          put 'stats_results', {:use_route => :leasingx, :lease_booking => {:time_frame => '月'} }
          response.should be_success
        end
       
        it "should allow sales dept head to pull stats" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'stats_results', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          10.times { FactoryGirl.create(:lease_booking) }
          put 'stats_results', {:use_route => :leasingx, :lease_booking => {:time_frame => '季'} }
          response.should be_success
        end
        
        it "should allow sales dept head to pull stats" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'stats_results', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          10.times { FactoryGirl.create(:lease_booking) }
          put 'stats_results',{:use_route => :leasingx, :lease_booking => {:time_frame => '年'} }
          response.should be_success
        end          
        
        it "should reject those without right" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          10.times { FactoryGirl.create(:lease_booking) }
          put 'stats_results', {:use_route => :leasingx, :lease_booking => {:time_frame => '月'}  }
          response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无统计权限！")      
        end
      end
    
    end

end