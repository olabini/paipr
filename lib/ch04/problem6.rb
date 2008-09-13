require 'gps_no_clobber'

gps = GPS.new([:son_at_home,
               :car_needs_battery,
               :have_phone_book,
               :have_money],
              GPS::SCHOOL_OPS)

if gps.solve(:have_money, :son_at_school)
  puts "Solved"
else
  puts "Not solved"
end
