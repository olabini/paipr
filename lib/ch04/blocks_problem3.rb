require 'blocks'
require 'pp'

gps = GPS2.new([[:a, :on, :b], 
                [:b, :on, :c],
                [:c, :on, :table],
                [:space, :on, :a], 
                [:space, :on, :table]],
               Blocks.make_ops([:a, :b, :c]))

pp gps.solve([:c, :on, :b], [:b, :on, :a])
