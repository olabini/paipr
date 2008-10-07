require 'plan_flight2'

module Search
  class << self
    def iter_wide(start, successors, cost_fn, 
                  width = 1, max = 100, &goal_p)
      dbg :search, "; Width: %d", width
      unless width > max
        beam(start, successors, cost_fn, 
             width, 
             &goal_p) ||
          iter_wide(start, successors, cost_fn, 
                    width + 1, max, &goal_p)
      end
    end
  end
end

if __FILE__ == $0
  debug :search
  p Search.iter_wide(1, 
                     Trees.finite_binary(15), 
                     Search.diff(12), 
                     &is(12))
end
