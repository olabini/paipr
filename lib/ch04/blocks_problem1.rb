require 'blocks'
require 'pp'

gps = GPS2.new([[:a, :on, :table], 
                [:b, :on, :table], 
                [:space, :on, :a], 
                [:space, :on, :b], 
                [:space, :on, :table]],
               Blocks.make_ops([:a, :b]))

pp gps.solve([:a, :on, :b], [:b, :on, :table])
