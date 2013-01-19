# encoding: utf-8

module Leasingx
  class LeaseBookingsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee  
    
    helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_stats_right?, :set_time_slot, :no_change_on_discount?, :return_purpose
    
    def index
      @title = '设备出租Booking'
      @lease_bookings = LeaseBooking.where("lease_date >= ?", Time.now - 365.day).order("lease_date DESC, customer_id, start_time").paginate(:per_page => 40, :page => params[:page])
      respond_to do |format|
        format.html
        format.js
        format.json { render json: @lease_bookings }
      end
    end
  
    def new
      @title = "输入Booking"
      if has_create_right?
        @lease_booking = LeaseBooking.new(params[:lease_booking], :as => :roles_new)
        @start_time = params[:start_time]
        @start_time_options = Array.new
        @end_time_options = Array.new
        @lease_item = LeaseItem.find_by_id(params[:lease_booking][:lease_item_id].to_i) if params[:lease_booking].present?
        
        respond_to do |format|
          format.html
          format.js
          format.json { render json: @lease_booking}
        end
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无权限输入出租Booking！")
      end
   
    end
  
    def create
      if has_create_right?
        @lease_booking = LeaseBooking.new(params[:lease_booking], :as => :roles_new)
        @lease_booking.sales_id = Customerx::Customer.find_by_id(params[:lease_booking][:customer_id].to_i).sales_id  #session[:user_id]
        @lease_booking.input_by_id = session[:user_id]
        @lease_booking.item_hourly_rate = LeaseItem.find_by_id(params[:lease_booking][:lease_item_id].to_i).hourly_rate
        
        if @lease_booking.save
            #send out email if saved
      
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Booking已保存！")
        else
          flash.now[:error] = "Booking无法保存！"
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无权限输入出租Booking！")
      end    
    end
  
    def edit
      @title = "更改Booking"
      @lease_booking = LeaseBooking.find(params[:id])
      @new_lease_booking = LeaseBooking.new(params[:lease_booking], :as => :roles_new)
      @start_time = params[:start_time]
      @start_time_options = Array.new
      @end_time_options = Array.new
      @start_time_options << @lease_booking.start_time
      @end_time_options << @lease_booking.end_time
       
      if !has_update_right?
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无更改Booking权限！")
      else
        respond_to do |format|
          format.html
          format.js
          format.json { render json: @lease_booking}
        end
      end
      
    end
  
    def update
      @lease_booking = LeaseBooking.find(params[:id])    
      if has_update_right?
        @lease_booking.input_by_id = session[:user_id]
        if @lease_booking.update_attributes(params[:lease_booking], :as => :roles_update)
          #update charge_rate
          if @lease_booking.lease_item_id_changed? || @lease_booking.discount_changed?
            @lease_booking.update_attribute(:charge_rate, LeaseItem.find_by_id(@lease_booking.lease_item_id).hourly_rate *
                                     (100 - @lease_booking.discount)/100.00)
          end
            #send out email with change listed
          #if @lease_booking.changed         
          #end
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Booking更改已保存!")
        else
          flash.now[:error] = "无法保存Booking更改"
          render 'edit'
   
        end
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无更改Booking权限！")
      end    
    end
  
    def destroy
      if has_destroy_right?
        @lease_booking = LeaseBooking.find(params[:id])
        @lease_booking.destroy
      
        redirect_to URI.escape(SUBURI + "/view_handler?index=0msg=Booking已删除")
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0msg=无删除权限")
      end
    end
  
    def show
      @title = "Booking内容"
      @lease_booking = LeaseBooking.find(params[:id])
      if !has_show_right?(@lease_booking)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无权限查看出租Booking")
      end
    end
    
    def search
      @lease_booking = LeaseBooking.new
    end
    
    def search_results
      @lease_booking = LeaseBooking.new(params[:lease_booking], :as => :roles_search)   
      @lease_bookings = @lease_booking.find_lease_bookings #.paginate(:per_page => 40, :page => params[:page])
      #seach params
      @search_params = search_params()    
    end
    
    def stats
      if has_stats_right?
        @lease_booking = LeaseBooking.new
      end
    end
    
    def stats_results
      if has_stats_right?
        @lease_booking = LeaseBooking.new(params[:lease_booking], :as => :roles_search)
      
        @lease_bookings = @lease_booking.find_lease_bookings
        
        @lease_bookings_stats = @lease_bookings.where("cancelled = ? AND completed = ?", false, true).order('lease_date DESC')
        @stats_params = "参数："+params[:lease_booking][:time_frame] + '，统计条数：'+ @lease_bookings.count.to_s
        group_bookings(params[:lease_booking][:time_frame]) #result in @lease_bookings_stats & @stats_params
        #retrieve stats parameters     
        @stats_params += ', ' + Customer.find_by_id(params[:lease_booking][:customer_id_search]).short_name if params[:lease_booking][:customer_id_search].present?
        @stats_params += ', ' + LeaseItem.find_by_id(params[:lease_booking][:lease_item_id_search]).name if params[:lease_booking][:lease_item_id_search].present?
        @stats_params += ', ' + User.find_by_id(params[:lease_booking][:sales_id_search]).name if params[:lease_booking][:sales_id_search].present?
  
        return if @lease_bookings_stats.blank?  #empty @lease_bookings_stats causes error in following code      
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无统计权限！")
      end     
    end
    
    protected
    
    def group_bookings(time_frame)
        #charge_rate in booking is the rate after discount.
        case time_frame #params[:lease_booking][:time_frame]
        when '周'
          @lease_bookings_stats = @lease_bookings_stats.where("lease_date > ?", 2.years.ago).all(:select => "lease_date, sum(total_hour) as total_hours, sum(total_hour * charge_rate ) as revenue, count(DISTINCT(customer_id)) as num_customer", 
                                  :group => "strftime('%Y/%W', lease_date)")
                            
        when '月'
          @lease_bookings_stats = @lease_bookings_stats.where("lease_date > ?", 3.years.ago).all(:select => "lease_date, sum(total_hour) as total_hours, sum(total_hour * charge_rate ) as revenue, count(DISTINCT(customer_id)) as num_customer", 
                                  :group => "strftime('%Y/%m', lease_date)")                     
        when '季'
          @lease_bookings_stats = @lease_bookings_stats.where("lease_date > ?", 4.years.ago).all(:select => "lease_date, sum(total_hour) as total_hours, sum(total_hour * charge_rate ) as revenue, count(DISTINCT(customer_id)) as num_customer,
                                  CASE WHEN cast(strftime('%m', lease_date) as integer) BETWEEN 1 AND 3 THEN 1 WHEN cast(strftime('%m', lease_date) as integer) BETWEEN 4 and 6 THEN 2 WHEN cast(strftime('%m', lease_date) as integer) BETWEEN 7 and 9 THEN 3 ELSE 4 END as quarter", 
                                  :group => "strftime('%Y', lease_date), quarter")                                
        when '年'
          @lease_bookings_stats = @lease_bookings_stats.where("lease_date > ?", 5.years.ago).all(:select => "lease_date, sum(total_hour) as total_hours, sum(total_hour * charge_rate ) as revenue, count(DISTINCT(customer_id)) as num_customer",
                                  :group => "strftime('%Y', lease_date)")                         
        end   
        
    end
    
    def search_params
      search_params = "参数："
      search_params += ' 开始日期：' + params[:lease_booking][:earliest_lease_date_search] if params[:lease_booking][:earliest_lease_date_search].present?
      search_params += ', 结束日期：' + params[:lease_booking][:latest_lease_date_search] if params[:lease_booking][:latest_lease_date_search].present?
      search_params += ', 测试项目 ：' + LeaseItem.find_by_id(params[:lease_booking][:lease_item_id_search]).name if params[:lease_booking][:lease_item_id_search].present?
      search_params += ', 客户 ：' + Customer.find_by_id(params[:lease_booking][:customer_id_search].to_i).short_name if params[:lease_booking][:customer_id_search].present?
      search_params += ', 业务员 ：' + User.find_by_id(params[:lease_booking][:sales_id_search].to_i).name if params[:lease_booking][:sales_id_search].present?
      search_params
    end  
    
    
    def has_create_right?
      grant_access?('create', 'leasingx_lease_bookings', nil, nil)
    end
    
    def has_update_right?
      grant_access?('update', 'leasingx_lease_bookings', nil, nil)
    end
    
    
    def has_stats_right?
      grant_access?('stats_results', 'leasingx_lease_bookings', nil, nil)
    end
    
    
    def has_show_right?(booking)
      grant_access?('show', 'leasingx_lease_bookings', nil, nil)
    end 
    
    def has_destroy_right?
      grant_access?('destroy', 'leasingx_lease_bookings', nil, nil)
    end
    
    def no_change_on_discount?(discount)
      true if sales? && discount > 10  
      true if sales_dept_head? && discount > 50
      false # for ceo and corp head
    end
    
    def set_time_slot
      @time_slot = ['12:00 AM','00:30 AM','01:00 AM','01:30 AM','02:00 AM','02:30 AM','03:00 AM' ,'03:30 AM','04:00 AM','04:30 AM','05:00 AM','05:30 AM','06:00 AM','06:30 AM','07:00 AM','07:30 AM','08:00 AM','08:30 AM',
                    '09:00 AM','09:30 AM','10:00 AM','10:30 AM','11:00 AM','11:30 AM','12:00 PM','12:30 PM','01:00 PM','01:30 PM','02:00 PM','02:30 PM','03:00 PM' ,'03:30 PM','04:00 PM','04:30 PM','05:00 PM',
                    '05:30 PM','06:00 PM','06:30 PM','07:00 PM','07:30 PM','08:00 PM','08:30 PM','09:00 PM','09:30 PM','10:00 PM','10:30 PM','11:00 PM','11:30 PM']   
    end
    
    def return_purpose
      ['产品开发', '达标测试', '产品投放市场前测试', '应客户要求测试','其它']
    end
  
  end

end