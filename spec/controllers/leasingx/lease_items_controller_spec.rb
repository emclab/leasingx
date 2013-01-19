# encoding: utf-8
require 'spec_helper'

module Leasingx

    describe LeaseItemsController do
    
      before(:each) do
        #the following recognizes that there is a before filter without execution of it.
        controller.should_receive(:require_signin)
        controller.should_receive(:require_employee)
        #controller.should_receive(:session_timeout)
      end
        
      render_views
      
      describe "show" do
        it "should success for everyone" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'show', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          li = FactoryGirl.create(:lease_item, :input_by_id => u.id)
          get 'show', {:use_route => :leasingx, :id => li.id  }
          response.should be_success
        end  
      end
      
      describe "GET 'index'" do
        it "should be successful" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'sales')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          li = FactoryGirl.create(:lease_item)
          get 'index',{:use_route => :leasingx}
              response.should be_success
        end
        
        it "should OK with member user" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          get 'index',{:use_route => :leasingx}
          response.should be_success
        end
      end
    
      describe "GET 'new'" do
      
        it "should be successful for corp head" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          get 'new', {:use_route => :leasingx}
          response.should be_success
        end
        
        it "should reject to create new for member user" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
          get 'new', {:use_route => :leasingx}
          response.should redirect_to URI.escape("/view_handler?index=0&msg=NO right to create lease item")
        end
      end
    
      describe "GET 'create'" do
        it "should be successful for eng dept head, corp head or ceo" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.attributes_for(:lease_item)
          post 'create', {:use_route => :leasingx, :lease_item => item }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Lease item created successfully")
        end
        
        it "should increse the lease item by one if successful" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.attributes_for(:lease_item)
          lambda do
            post 'create', {:use_route => :leasingx, :lease_item => item }
          end.should change(LeaseItem, :count).by(1)
        end
        
        it "should reject user without proper right to save the item" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.attributes_for(:lease_item)
          post 'create', {:use_route => :leasingx, :lease_item => item  }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=NO right to create lease item")   
        end
    
        it "should not increse the lease item if NOT successful" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.attributes_for(:lease_item)
          lambda do
            post 'create', {:use_route => :leasingx, :lease_item => item }
          end.should change(LeaseItem, :count).by(0)
        end
            
      end
    
      describe "GET 'edit'" do
        it "should be successful for the user of dept head or above " do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          get 'edit', {:use_route => :leasingx,:id => item.id }
          response.should be_success
        end
        
        it "should redirect to other page for user who does not have rights" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          get 'edit',{:use_route => :leasingx, :id => item.id }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=NO right to edit lease item")
        end
      end
    
      describe "GET 'update'" do
        it "should be successful with proper user" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'eng_dept_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'create', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          post 'update', {:use_route => :leasingx, :id => item.id, :lease_item => {:name => 'modified item name'} }
          response.should redirect_to URI.escape("/view_handler?index=0&msg=Lease item updated successfully")
        end
        
        it "should render edit if update was not saved" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          action = FactoryGirl.create(:authentify_sys_action_on_table, :action => 'update', :table_name => 'leasingx_lease_items')
          right = FactoryGirl.create(:authentify_sys_user_right, :sys_user_group_id => ugrp.id, :sys_action_on_table_id => action.id)
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          session[:corp_head] = true
          post 'update', {:use_route => :leasingx, :id => item.id, :lease_item => {:name => 'nil'}}
          flash.now.should_not be_nil
          response.should render_template(:action=> "edit") 
        end
        
        it "should reject for user without proper role and position" do
          ugrp = FactoryGirl.create(:authentify_sys_user_group, :user_group_name => 'corp_head')
          ul = FactoryGirl.create(:authentify_user_level, :sys_user_group_id => ugrp.id )
          u = FactoryGirl.create(:authentify_user, :user_levels => [ul])
          session[:user_id] = u.id
          session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)

          item = FactoryGirl.create(:lease_item)
          post 'update', {:use_route => :leasingx,  :id => item.id, :lease_item => {:name => 'modified name'}}
          response.should redirect_to URI.escape("/view_handler?index=0&msg=NO right to update lease item")
        end
      end
    
    end

end