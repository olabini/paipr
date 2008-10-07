require 'iter_widening'

module Search
  class << self
    def graph(states, 
              successors, 
              combiner, 
              state_eq = proc{ |a, b| a == b}, 
              old_states = [], 
              &goal_p)
      dbg :search, ";; Search: %p", states
      return nil if states.empty?
      return states.first if goal_p[states.first]
      graph(combiner[new_states(states,
                                successors,
                                state_eq,
                                old_states),
                    states[1..-1]],
            successors,
            combiner,
            state_eq,
            old_states.find { |os| state_eq[os, states.first] } ? 
              old_states :
              [states.first] + old_states,
            &goal_p)
    end
    
    def new_states(states, successors, state_eq, old_states)
      successors[states.first].select do |state|
        !(states.find { |s|
            state_eq[state,s]
          } || old_states.find { |s|
            state_eq[state,s]
          })
      end
    end
  end
end

def next2(x)
  [x+1, x+2]
end

if __FILE__ == $0
  debug :search
  p Search.graph([1], 
                 proc { |n| next2(n) },
                 proc { |x,y| y+x },
                 &is(6))
end
