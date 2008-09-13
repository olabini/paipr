require 'gps3'

module Blocks
  class << self
    def make_ops(blocks)
      ops = []
      blocks.each do |a|
        blocks.each do |b|
          unless a == b
            blocks.each do |c|
              unless [a, b].include?(c)
                ops << move_op(a, b, c)
              end
            end
            ops << move_op(a, :table, b)
            ops << move_op(a, b, :table)
          end
        end
      end
      ops
    end
    
    # Make an operator to move A from B to C
    def move_op(a, b, c)
      GPS2.op([:move, a, :from, b, :to, c],
              :preconds => [[:space, :on, a], [:space, :on, c], [a, :on, b]],
              :add_list => move_ons(a, b, c),
              :del_list => move_ons(a, c, b))
    end
    
    def move_ons(a, b, c)
      b == :table ? [[a, :on, c]] :
        [[a, :on, c], [:space, :on, b]]
    end
  end
end
