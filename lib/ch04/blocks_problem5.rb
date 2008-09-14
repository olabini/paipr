require 'blocks'
require 'pp'

gps = GPS2.new([[:c, :on, :a], 
                [:a, :on, :table],
                [:b, :on, :table],
                [:space, :on, :b], 
                [:space, :on, :c], 
                [:space, :on, :table]],
               Blocks.make_ops([:a, :b, :c]))

pp gps.solve([:c, :on, :table], [:a, :on, :b])
