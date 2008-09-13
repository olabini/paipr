require 'gps2'
require 'pp'

gps = GPS2.new([:son_at_home, 
                :car_needs_battery,
                :have_money],
              GPS::SCHOOL_OPS)
pp gps.solve(:son_at_school)
