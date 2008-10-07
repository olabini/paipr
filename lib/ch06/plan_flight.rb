require 'beam_search'

City = Struct.new(:name, :long, :lat)

class City
  CITIES = 
    [
     ['Atlanta',        84.23, 33.45],
     ['Boston',         71.05, 42.21],
     ['Chicago',        87.37, 41.50],
     ['Denver',        105.00, 39.45],
     ['Eugene',        123.05, 44.03],
     ['Flagstaff',     111.41, 35.13],
     ['Grand Junction',108.37, 39.05],
     ['Houston',       105.00, 34.00],
     ['Indianapolis',   86.10, 39.46],
     ['Jacksonville',   81.40, 30.22],
     ['Kansas City',    94.35, 39.06],
     ['Los Angeles',   118.15, 34.03],
     ['Memphis',        90.03, 35.09],
     ['New York',       73.58, 40.47],
     ['Oklahoma City',  97.28, 35.26],
     ['Pittsburgh',     79.57, 40.27],
     ['Quebec',         71.11, 46.49],
     ['Reno',          119.49, 39.30],
     ['San Francisco', 122.26, 37.47],
     ['Tampa',          82.27, 27.57],
     ['Victoria',      123.21, 48.25],
     ['Wilmington',     77.57, 34.14]
    ].map do |name, long, lat| 
    new(name, long, lat) 
  end

  EARTH_DIAMETER = 12765.0
  
  def air_distance_to(city)
    d = distance(self.xyz_coords, city.xyz_coords)
    EARTH_DIAMETER * Math.asin(d/2)
  end

  def xyz_coords
    psi = deg_to_radians(self.lat)
    phi = deg_to_radians(self.long)
    [
     Math.cos(psi) * Math.cos(phi),
     Math.cos(psi) * Math.sin(phi),
     Math.sin(psi)
    ]
  end
  
  def distance(point1, point2)
    Math.sqrt(point1.
              zip(point2).
              map { |a, b| (a-b)**2 }.
              inject(0) { |sum, e| sum+e })
  end

  def deg_to_radians(deg)
    (deg.truncate + ((deg%1) * (100.0/60.0))) * 
      Math::PI * 
      1.0/180.0
  end
  
  def neighbors
    CITIES.select do |c|
      c != self &&
        self.air_distance_to(c) < 1000.0
    end
  end
  
  class << self
    def [](name)
      CITIES.find { |c| c.name == name }
    end

    def trip(start, dest)
      Search.beam(start, 
                  proc { |c| c.neighbors },
                  proc { |c| c.air_distance_to(dest) },
                  1,
                  &is(dest))
    end
  end
end

if __FILE__ == $0
  debug :search
  City.trip(City['San Francisco'], City['Boston'])
  p "---"
  City.trip(City['Boston'], City['San Francisco'])
end
