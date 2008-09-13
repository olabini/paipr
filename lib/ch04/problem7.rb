require 'gps'

gps = GPS.new([:son_at_home,
               :car_needs_battery,
               :have_money],
              GPS::SCHOOL_OPS + 
              [
               GPS::Op.new(:ask_phone_number, 
                           [:in_communication_with_shop],
                           [:know_phone_number],
                           [])
              ])

if gps.solve(:son_at_school)
  puts "Solved"
else
  puts "Not solved"
end
