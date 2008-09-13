require 'gps'

gps = GPS.new([:son_at_home, 
               :have_money,
               :car_works],
              GPS::SCHOOL_OPS)

if gps.solve(:have_money, :son_at_school)
  puts "Solved"
else
  puts "Not solved"
end
