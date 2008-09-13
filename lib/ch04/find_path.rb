require 'maze'
require 'gps3'

module Maze
  class << self
    def find_path(start, finish)
      results = GPS2.new([[:at, start]], Maze::Ops).
        solve([:at, finish])
      unless results.empty?
        [start] + ((results - [[:start]]).map do |action|
          destination(action)
        end)
      end
    end
  
    def destination(action)
      action[1][4]
    end
  end
end

pp Maze.find_path(1, 25)
pp Maze.find_path(1, 1)
pp(Maze.find_path(1, 25) == Maze.find_path(25,1).reverse)
