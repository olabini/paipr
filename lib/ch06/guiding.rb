
require 'search'

module Search
  class << self
    def diff(num)
      lambda do |x|
        (x - num).abs
      end
    end
    
    def sorter(&cost_fn)
      lambda do |new, old|
        (new + old).sort_by do |n| 
          cost_fn[n] 
        end
      end
    end
    
    def best_first(start, successors, cost_fn, &goal_p)
      tree_search([start], successors, sorter(&cost_fn), &goal_p)
    end
  end
end

def price_is_right(price)
  lambda do |x|
    if x > price
      100000000
    else
      price - x
    end
  end
end

if __FILE__ == $0
  debug :search
  Search.best_first(1, 
                    proc{|v| Trees.binary(v)}, 
                    Search.diff(12),
                    &is(12))

  Search.best_first(1, 
                    proc{|v| Trees.binary(v)}, 
                    price_is_right(12),
                    &is(12))
end
