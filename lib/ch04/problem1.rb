require 'gps'

gps = GPS.new([:son_at_home, 
               :car_needs_battery, 
               :have_money, 
               :have_phone_book],
              GPS::SCHOOL_OPS)
if gps.solve(:son_at_school)
  puts "Solved"
else
  puts "Not solved"
end
