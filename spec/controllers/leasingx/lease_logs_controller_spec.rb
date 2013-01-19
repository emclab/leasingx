# encoding: utf-8
require 'spec_helper'

module Leasingx

    describe LeaseLogsController do
    
      before(:each) do
        #the following recognizes that there is a before filter without execution of it.
        controller.should_receive(:require_signin)
        controller.should_receive(:require_employee)
        #controller.should_receive(:session_timeout)
      end
        
      render_views
      
      describe "'index'" do
        it "should be successful all employee " do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_bookings')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          log = FactoryGirl.create(:lease_log)
          get 'index',{:use_route => :leasingx}
          response.should be_success
        end
      end
    
      describe "'new'" do
        it "should reject those without rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          log = FactoryGirl.attributes_for(:lease_log, :lease_booking_id => booking.id)
          get 'new', {:use_route => :leasingx, :lease_booking_id => booking.id  }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无权输入Log!") 
        end
        
        it "should be successful for eng member" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          customer = FactoryGirl.create(:customerx_customer)
          item = FactoryGirl.create(:lease_item)      
          booking = FactoryGirl.create(:lease_booking, :customer_id => customer.id, :lease_item_id => item.id) 
          log = FactoryGirl.attributes_for(:lease_log, :lease_booking_id => booking.id)
          get 'new' ,{:use_route => :leasingx, :lease_booking_id => booking.id }
          response.should be_success
        end
        
       it "should be successful for eng dept head" do
         ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
         action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
         right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
         ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
         u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
         session[:user_id] = u.id
         session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          customer = FactoryGirl.create(:customerx_customer)
          item = FactoryGirl.create(:lease_item)      
          booking = FactoryGirl.create(:lease_booking, :customer_id => customer.id, :lease_item_id => item.id) 
          log = FactoryGirl.attributes_for(:lease_log, :lease_booking_id => booking.id)
          get 'new', {:use_route => :leasingx, :lease_booking_id => booking.id  }
          response.should be_success
        end
            
      end
    
      describe "'create'" do
        
        it "should reject those without right" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          get 'create',{:use_route => :leasingx}
          response.should redirect_to URI.escape("/view_handler?index=0&msg=无权输入Log!")       
        end
        
        it "should be successful for eng member" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          log = FactoryGirl.attributes_for(:lease_log, :lease_booking_id => booking.id)      
          get 'create',{:use_route => :leasingx, :lease_booking_id => booking, :lease_log => log   }
          response.should redirect_to lease_booking_path(booking)
        end
        
        it "should be successful for eng dept head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          log = FactoryGirl.attributes_for(:lease_log, :lease_booking_id => booking.id)      
          get 'create',{:use_route => :leasingx, :lease_booking_id => booking, :lease_log => log }
          response.should redirect_to lease_booking_path(booking)
        end
            
      end
      
      describe "show" do
        it "should display log content" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          customer = FactoryGirl.create(:customerx_customer)
          item = FactoryGirl.create(:lease_item)      
          booking = FactoryGirl.create(:lease_booking, :customer_id => customer.id, :lease_item_id => item.id) 
          log = FactoryGirl.create(:lease_log, :lease_booking_id => booking.id, :input_by_id => u.id)
          get 'show',{:use_route => :leasingx, :lease_booking_id => booking.id, :id => log.id }
          response.should be_success
        end
      end
      
      describe "destroy" do
        it "should destroy the record for end dept head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'destroy', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          log = FactoryGirl.create(:lease_log, :lease_booking_id => booking.id)
          get 'destroy',{:use_route => :leasingx, :lease_booking_id => booking.id, :id => log.id }
          response.should redirect_to lease_booking_path(booking)      
        end
        
        it "should reduce the record count by 1 after successful delete" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'destroy', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          booking = FactoryGirl.create(:lease_booking)
          log = FactoryGirl.create(:lease_log, :lease_booking_id => booking.id)
          lambda do
            get 'destroy',{:use_route => :leasingx, :lease_booking_id => booking.id, :id => log.id }
          end.should change(LeaseLog, :count).by(-1)    
        end
      end
    
    end

end