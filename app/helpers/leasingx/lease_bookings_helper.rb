
module Leasingx
  
    module LeaseBookingsHelper
      
          
      
      def booked_time_slots (lease_booking, o_lease_booking)
        slots = Hash.new
        if lease_booking
          lease_booked_list = LeaseBooking.where("Date(lease_date) = :lease_date and lease_item_id = :lease_item_id", 
                                                  :lease_date => lease_booking.lease_date, :lease_item_id => lease_booking.lease_item_id)
          if lease_booked_list.empty?
            slots[Time.strptime("24:00", "%H:%M")] = Time.strptime("24:00", "%H:%M")
          else
            lease_booked_list.each do |lbl|
              unless o_lease_booking && (lbl.start_time == o_lease_booking.start_time)
                slots[Time.strptime(lbl.start_time, '%I:%M %p')]=Time.strptime(lbl.end_time, '%I:%M %p')
              end
            end
          end
        end
        slots
      end 
      
      def start_time_slots (lease_booking, o_lease_booking)
        s_slots = Array.new
        empty_slots = empty_time_slots(lease_booking, o_lease_booking)
        empty_slots.keys.each do |es|
          s_slots << es
          for i in 0...empty_slots[es].length - 1
            s_slots << empty_slots[es][i]
          end
        end
        s_slots
      end
      
      def end_time_slots (lease_booking, o_lease_booking, start_time)
        e_slots = Array.new
        empty_slots = empty_time_slots(lease_booking, o_lease_booking)
        
        if empty_slots.has_key?(start_time)
          e_slots = empty_slots[start_time]
        else
          b = false
          a_empty_slots = empty_slots[find_start_time(empty_slots, start_time)]
          a_empty_slots.each do |aes|
            if b
              e_slots << aes
            end
            if aes == start_time
              b = true
            end     
          end
        end
          
        e_slots
      end
      
      def empty_time_slots(lease_booking, o_lease_booking)
        booked_slots = booked_time_slots(lease_booking, o_lease_booking)
        empty_slots = Hash.new
        
        #if !booked_slots.empty?
          d_start = Time.strptime("00:00", "%H:%M")
          d_end = Time.strptime("24:00", "%H:%M")
          start_time = booked_slots.keys.sort << d_end
          
          if start_time[0] != d_start
            empty_slots[d_start.strftime("%I:%M %p")]=e_time_slots(d_start, start_time[0])
            d_start=booked_slots[start_time[0]]
          end
          start_time.each do |x|
            if d_start == x
              d_start = booked_slots[x]
            else
              empty_slots[d_start.strftime("%I:%M %p")] = e_time_slots(d_start, x)
              d_start = booked_slots[x]
            end
          #end
        end
        empty_slots 
      end
      
      def e_time_slots (start_time, end_time)
        slots = Array.new
        until start_time >= end_time
          start_time += 1800
          slots << start_time.strftime("%I:%M %p")
        end
        slots
      end
      
      def find_start_time(empty_slots, start_time)
        s_time = nil
      
        empty_slots.keys.each do |es|
          for i in 0...empty_slots[es].length
            if empty_slots[es][i] == start_time         
              return es
            end
          end
        end
      end
    end

end