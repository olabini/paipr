
$:.unshift '../ch04'
require 'dbg'

module Search
  class << self
    def tree_search(states, successors, combiner, &goal_p)
      dbg :search, ";; Search %p", states
      return nil if !states || states.empty?
      if goal_p[states.first]
        states.first
      else
        tree_search(combiner[successors[states.first], states[1..-1]], 
                    successors, 
                    combiner, 
                    &goal_p)
      end
    end
    
    def depth_first(start, successors, &goal_p)
      tree_search([start], 
                  successors, 
                  proc{ |x, y| x+y }, 
                  &goal_p)
    end
    
    def breadth_first(start, successors, &goal_p)
      tree_search([start], 
                  successors, 
                  proc{ |x, y| y + x }, 
                  &goal_p)
    end
  end
end

module Trees
  class << self
    def binary(x)
      [2*x, 2*x + 1]
    end

    def finite_binary(n)
      proc do |x|
        binary(x).select { |child| child<=n }
      end
    end
  end
end

def is(value)
  lambda { |x| x == value }
end

