require 'beam_search'

module Search
  class << self
    def all(start, successors, cost_fn, beam_width, &goal_p)
      solutions = []
      beam(start,
           successors,
           cost_fn,
           beam_width,           
           &(proc do |x| 
               solutions << x if goal_p[x]
               nil
             end)
           )
      solutions
    end
  end
end
