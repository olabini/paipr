require 'gps'

gps = GPS.new([:son_at_home, 
               :car_works],
              GPS::SCHOOL_OPS)

if gps.solve(:son_at_school)
  puts "Solved"
else
  puts "Not solved"
end
