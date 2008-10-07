require 'graph_search'

module Search
  class << self
    def a_star(paths, 
               successors, 
               cost_fn, 
               cost_left_fn, 
               state_eq = proc { |a, b| a == b}, 
               old_paths = [], 
               &goal_p)
      dbg :search, ";; Search: %s", paths

      return [] if paths.empty?
      return [paths.first, paths] if goal_p[paths.first.state]

      path = paths.shift
      state = path.state
      old_paths = insert_path(path, old_paths)

      successors[state].each do |state2|
        cost = path.cost_so_far + cost_fn[state, state2]
        cost2 = cost_left_fn[state2]
        path2 = Path.new(state2, path, cost, cost+cost2)

        old = find_path(state2, paths, state_eq)
        if old
          if better_path(path2, old)
            paths = insert_path(path2, paths - [old])
          end
        else
          old = find_path(state2, old_paths, state_eq)
          if old
            if better_path(path2, old)
              paths = insert_path(path2, paths)
              old_paths = old_paths - [old]
            end
          else
            paths = insert_path(path2, paths)
          end
        end
      end
      a_star(paths, 
             successors, 
             cost_fn, 
             cost_left_fn, 
             state_eq, 
             old_paths, 
             &goal_p)
    end
    
    def find_path(state, paths, state_eq)
      paths.find do |p|
        state_eq[p.state, state]
      end
    end
    
    def better_path(path1, path2)
      path1.total_cost < path2.total_cost
    end
    
    def insert_path(path, paths)
      (paths + [path]).sort_by { |p| p.total_cost }
    end
    
    def path_states(path)
      return [] if !path
      [path.state] + path_states(path.previous)
    end
  end
end

if __FILE__ == $0
  debug :search
  p Search.path_states(Search.a_star([Path.new(1)],
                                     proc { |n| next2(n) },
                                     proc { |x,y| 1 },
                                     Search.diff(6),
                                     &is(6)).first)
end
