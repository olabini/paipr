require 'guiding'

module Search
  class << self
    def beam(start, successors, cost_fn, beam_width, &goal_p)
      tree_search([start], successors, proc do |old, new|
                    sorted = sorter(&cost_fn)[old,new]
                    if beam_width > sorted.length
                      sorted
                    else
                      sorted[0...beam_width]
                    end
                  end,
                  &goal_p)
    end
  end
end

if __FILE__ == $0
  debug :search
  Search.beam(1, 
              proc{|v| Trees.binary(v)}, 
              price_is_right(12),
              2,
              &is(12))

  # Search.beam(1, 
  #             proc{|v| Trees.binary(v)}, 
  #             Search.diff(12),
  #             2,
  #             &is(12))
end
