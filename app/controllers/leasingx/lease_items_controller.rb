# encoding: utf-8

module Leasingx

  class LeaseItemsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method :has_update_create_right?
      
    def index
      @title = "出租设备"
      if has_update_create_right?
        @lease_items = LeaseItem.order('name')
      else
        @lease_items = LeaseItem.active_lease_item.order('name')
      end
    
    end
  
    def new
      if has_update_create_right?
        @lease_item = LeaseItem.new
      else
        #redirect to previous page
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO right to create lease item")
      end
      @title = "输入出租设备"    
    end
  
    def create
      if has_update_create_right?
        @lease_item = LeaseItem.new(params[:lease_item], :as => :roles_new)
        @lease_item.input_by_id = session[:user_id]
        if @lease_item.save
          #send out email
          #redirect
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Lease item created successfully")
        else
          #back to new
          render 'new'
        end
      else
        #back to previous page
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO right to create lease item")
      end
    end
  
    def edit
      if has_update_create_right?
        @lease_item = LeaseItem.find(params[:id])
      else
        #redirect to previous page
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO right to edit lease item")
      end 
      @title = "更新出租设备"
    end
  
    def update
      if has_update_create_right?
        @lease_item = LeaseItem.find(params[:id])
        @lease_item.input_by_id = session[:user_id]
        if @lease_item.update_attributes(params[:lease_item], :as => :roles_update)
     
          #send out email
          #redirect
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Lease item updated successfully")
        else
          #back to new
          flash.now[:notice] = "Item NOT updated"
          render 'edit'
        end
      else
        #back to previous page
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=NO right to update lease item")
      end    
    end
    
    def show
      @lease_item = LeaseItem.find(params[:id])
    end
    
    def search
      @lease_item = LeaseItem.new
    end
    
    def search_results
      @lease_item = LeaseItem.new(params[:lease_item], :as => :roles_search)
      
      @lease_items = @lease_item.find_lease_items
    end
    
    protected

    def has_update_create_right?
      grant_access?('update', 'leasingx_lease_items', nil, nil) or
      grant_access?('create', 'leasingx_lease_items', nil, nil)
    end
  
  end

end