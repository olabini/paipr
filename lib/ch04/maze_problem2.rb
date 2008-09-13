require 'maze'
require 'gps3'

gps = GPS2.new([[:at, 1]],
               Maze::Ops)
pp gps.solve([:at, 25])
