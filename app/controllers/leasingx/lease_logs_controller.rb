# encoding: utf-8


module Leasingx

  class LeaseLogsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method :has_create_right?, :set_total_hour, :has_destroy_right?
      
    def index
      @title = '租赁log'
      @lease_logs = LeaseLog.order('id DESC')
    end
  
    def new
      @title = '输入租赁log' 
      @lease_booking = LeaseBooking.find(params[:lease_booking_id])
      @lease_log = @lease_booking.lease_logs.new()    
      if !has_create_right?  
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无权输入Log!")
      end   
    end
  
    def create
      if has_create_right?
        @lease_booking = LeaseBooking.find(params[:lease_booking_id])
        @lease_log = @lease_booking.lease_logs.new(params[:lease_log], :as => :roles_new)      
        @lease_log.input_by_id = session[:user_id]
        if @lease_log.save
          #send out notification email
          redirect_to lease_booking_path(@lease_booking), :notice => "Log已保存！"
        else
          flash.new[:error] = "无法保存Log"
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无权输入Log!")
      end
    end
    
    def show
      @title = 'Log内容'  
      @lease_booking = LeaseBooking.find(params[:lease_booking_id])   
      @lease_log = @lease_booking.lease_logs.find(params[:id])
    end
    
    def destroy
      if has_destroy_right?
        @lease_booking = LeaseBooking.find(params[:lease_booking_id])
        @lease_log = @lease_booking.lease_logs.find(params[:id])
        @lease_log.destroy
        respond_to do |format|
          #format.html { redirect_to URI.escape("/view_handler?index=0&msg=Log已删除!")}
          format.html { redirect_to lease_booking_path(@lease_booking), :notice => "log已删除!"}
          format.js
        end
      end
    end
    
    protected
    
    def has_create_right?
      grant_access?('create', 'leasingx_lease_items', nil, nil)
    end
  
    def has_destroy_right?
      grant_access?('destroy', 'leasingx_lease_items', nil, nil)
    end
    
    def set_total_hour
      return [['0.5', 0.5], ['1.0', 1.0],['1.5', 1.5],['2.0', 2.0],['2.5', 2.5],['3.0', 3.0],['3.5', 3.5],['4.0', 4.0],['4.5', 4.5],['5.0', 5.0],
              ['5.5', 5.5],['6.0', 6.0],['6.5', 6.5],['7.0', 7.0],['7.5', 7.5],['8.0', 8.0],['8.5', 8.5],['9.0', 9.0],['9.5', 9.5],['10.0', 10.0],
              ['10.5', 10.5],['11.0', 11.0],['11.5', 11.5],['12.0', 12.0],['12.5', 12.5],['13.0', 13.0],['13.5', 13.5],['14.0', 14.0],['14.5', 14.5],
              ['15.0', 15.0],['15.5', 15.5],['16.0', 16.0],['16.5', 16.5],['17.0', 17.0],['17.5', 17.5],['18.0', 18.0],['18.5', 18.5],['19.0', 19.0],
              ['19.5', 19.5],['20.0', 20.0],['20.5', 20.5],['21.0', 21.0],['21.5', 21.5],['22.0', 22.0],['22.5', 22.5],['23.0', 23.0],['23.5', 23.5],
              ['24.0', 24.0]]
    end
  end

end