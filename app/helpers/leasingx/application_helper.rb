# encoding: UTF-8
module Leasingx

    module ApplicationHelper
      def title
        base_title = "EMC Lab"
        if @title.nil?
          base_title
        else
          "#{base_title} | #{@title}"
        end
      end
    
      def return_sales
        return User.user_status('active').user_type('employee').joins(:user_levels).where(:user_levels => {:role => ['sales','sales_dept_head', 'corp_head']}).order("name ASC")    
      end
        
      def link_to_remove_nest_fields(name, f)  
        f.hidden_field(:_destroy) + link_to_function(name, "remove_nest_fields(this)")  
      end  
      
      def link_to_add_nest_fields(name, f, association)  
          new_object = f.object.class.reflect_on_association(association).klass.new  
          fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
            render(association.to_s.singularize + "_fields", :f => builder)  
          end  
          link_to_function(name, ("add_nest_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))  
      end  
      
      def return_expense_type
        return ['生产开支', '非生产开支']
      end 
      
      def return_expense_for_production
        return ['设备采购','设备校准','设备维护/修', '外包费用', '耗材','零部件','佣金','快递费','接待费','杂项'] 
      end 
      
      def return_expense_for_overhead
        return ['水电','房租','办公用品','卫生用品','油-汽车','维修-汽车','保险-汽车','路桥-汽车','其他-汽车','工资','加班','福利','奖金','网络-通讯','固话-通讯','移动-通讯','业务提成','差旅费','餐费','交际','交通费','广告费','国税','地税','杂项']
      end
      
      def to_chn(str_sym)
        h = {:username => '用户名', 
          :password => '密码', 
          :password_confirmation => '确认密码',
          :user_type => '用户类型',
          :user_levels => '用户职位',
          :role => '职位',
          :updated_at => '修改时间',
          'eng' => '测试工程',
          'customer' => '客户',
          'subcontractor' => '外包商',
          'employee' => '公司员工',
          :sales => '业务员',
          :eng => '工程师',
          :search => '搜索',
          :standard => '测试标准',
          :test_item => '测试项目',
          :lease_usage_record => '测试记录单',
          :quote => '报价单',
          :invoice => '账单',
          :invoice_date => '付款日期',
          :paid_out_date => '付清日期',
          :overdue_days => '过期未付天数',
          :test_plan => '开案单',
          :customer => '客户',
          :earliest_created_at => '最早创建日期',
          :latest_created_at => '最晚创建日期',
          :category => '产品/厂家分类',
          :search_results => '搜索结果',
          :stats => '统计',
          :keyword => '关键字'}
        h[str_sym]
      end
      
      def corp_title
        corp_title = "深圳市劲升硕科技有限公司"
      end
      
      def set_time_slot
        @time_slot = ['12:00 AM','00:30 AM','01:00 AM','01:30 AM','02:00 AM','02:30 AM','03:00 AM' ,'03:30 AM','04:00 AM','04:30 AM','05:00 AM','05:30 AM','06:00 AM','06:30 AM','07:00 AM','07:30 AM','08:00 AM','08:30 AM',
                      '09:00 AM','09:30 AM','10:00 AM','10:30 AM','11:00 AM','11:30 AM','12:00 PM','12:30 PM','01:00 PM','01:30 PM','02:00 PM','02:30 PM','03:00 PM' ,'03:30 PM','04:00 PM','04:30 PM','05:00 PM',
                      '05:30 PM','06:00 PM','06:30 PM','07:00 PM','07:30 PM','08:00 PM','08:30 PM','09:00 PM','09:30 PM','10:00 PM','10:30 PM','11:00 PM','11:30 PM']   
      end
      
      def return_time_frame
        ['周','月','季','年']  #week, month, quarter, year
      end
      
      def return_time_frame1
        ['月','年']  # month, year
      end  
    end
    
end