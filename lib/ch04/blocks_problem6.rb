require 'blocks'
require 'pp'

gps = GPS2.new([[:c, :on, :a], 
                [:a, :on, :table],
                [:b, :on, :table],
                [:space, :on, :c], 
                [:space, :on, :b], 
                [:space, :on, :table]],
               Blocks.make_ops([:a, :b, :c]))

pp gps.solve([:a, :on, :b], [:b, :on, :c])
pp gps.solve([:b, :on, :c], [:a, :on, :b])
