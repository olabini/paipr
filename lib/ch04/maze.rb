require 'gps2'
require 'pp'

module Maze
  class << self
    def make_ops(pair)
      [make_op(pair[0], pair[1]),
       make_op(pair[1], pair[0])]
    end

    def make_op(here, there)
      GPS2::op([:move, :from, here, :to, there],
               :preconds => [[:at, here]],
               :add_list => [[:at, there]],
               :del_list => [[:at, here]])
    end
  end
  
  Ops = [[1,2], [2,3], [3,4], [4,9], [9,14], [9,8], 
         [8,7], [7,12], [12,13], [12,11], [11,6], 
         [11,16], [16,17], [17,22], [21,22], [22,23],
         [23,18], [23,24], [24,19], [19,20], [20, 15], 
         [15,10], [10,5], [20,25]].inject([]) do |sum, obj| 
    sum + make_ops(obj) 
  end
end

