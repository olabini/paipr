require 'plan_flight'

class Path
  attr_accessor :state, :previous, :cost_so_far, :total_cost

  def initialize(state = nil, 
                 previous = nil, 
                 cost_so_far = 0,
                 total_cost = 0)
    self.state = state
    self.previous = previous
    self.cost_so_far = cost_so_far
    self.total_cost = total_cost
  end

  def map(&block)
    res = [block[state]]
    if previous
      res + previous.map(&block)
    else 
      res
    end
  end
  
  def to_s
    "#<Path to %s cost %.1f>" % [self.state, self.total_cost]
  end
end

class City
  class << self
    def trip(start, dest, beam_width = 1)
      Search.beam(Path.new(start), 
                  path_saver(proc { |c| c.neighbors }, 
                             proc { |c, c2| c.air_distance_to(c2) },
                             proc { |c| c.air_distance_to(dest) }),
                  proc { |p| p.total_cost },
                  beam_width,
                  &is(dest, :state))
    end
  end
end

def is(value, key = nil)
  if key
    lambda { |path| path.send(key) == value }
  else
    lambda { |path| path == value }
  end
end

def path_saver(successors, cost_fn, cost_left_fn)
  lambda do |old_path|
    old_state = old_path.state
    successors[old_state].map do |new_state|
      old_cost = old_path.cost_so_far + 
        cost_fn[old_state, new_state]
      Path.new(new_state, 
               old_path, 
               old_cost, 
               old_cost + cost_left_fn[new_state])
    end
  end
end

def show_city_path(path)
  puts "#<Path %.1f km: %s>" % [path.total_cost, path.map { |s| s.name }.reverse.join(' - ')]
end

if __FILE__ == $0
  show_city_path(City.trip(City['San Francisco'], City['Boston'], 1))
  show_city_path(City.trip(City['Boston'], City['San Francisco'], 1))
  show_city_path(City.trip(City['Boston'], City['San Francisco'], 3))
end
