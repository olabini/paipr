require 'gps3'
require 'pp'

gps = GPS2.new([:son_at_home, 
                :have_money, 
                :have_works],
              GPS::SCHOOL_OPS + 
               [
                GPS2::op(:taxi_son_to_school,
                         :preconds => [:son_at_home, 
                                       :have_money],
                         :add_list => [:son_at_school],
                         :del_list => [:son_at_home, 
                                       :have_money])
               ])
debug :gps
pp gps.solve(:son_at_school, :have_money)
