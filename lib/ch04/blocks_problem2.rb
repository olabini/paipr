require 'blocks'
require 'pp'

gps = GPS2.new([[:a, :on, :b], 
                [:b, :on, :table], 
                [:space, :on, :a], 
                [:space, :on, :table]],
               Blocks.make_ops([:a, :b]))

pp gps.solve([:b, :on, :a])
