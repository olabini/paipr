require 'gps'
require 'gps_no_clobber'
require 'dbg'

module Enumerable
  def some?
    self.each do |v|
      result = yield v
      return result if result
    end
  end
end

class GPS::Op
  def convert!
    unless self.add_list.any? do |l| 
        l.is_a?(Array) && l.first == :executing 
      end
      self.add_list << [:executing, self.action]
    end
    self
  end
end

GPS::SCHOOL_OPS.each do |op|
  op.convert!
end

class GPS2 < GPS
  class << self
    def op(action, parts = {})
      GPS::Op.new(action, 
             parts[:preconds], 
             parts[:add_list], 
             parts[:del_list]).convert!
    end
  end

  def solve(*goals)
    achieve_all([[:start]] + @state, goals, []).grep(Array)
  end
  
  def achieve_all(state, goals, goal_stack)
    current_state = goals.inject(state) do |current_state, g|
      return [] if current_state.empty?
      achieve(current_state, g, goal_stack)
    end
    if goals.subset_of?(current_state)
      current_state
    else
      []
    end
  end
  
  def achieve(state, goal, goal_stack)
    dbg_indent(:gps, goal_stack.length, "Goal: %p", goal)

    if state.include?(goal)
      state
    elsif goal_stack.include?(goal)
      []
    else
      @ops.find_all do |op| 
        appropriate?(goal, op) 
      end.some? do |op| 
        apply(state, goal, op, goal_stack)
      end || []
    end
  end
  
  def apply(state, goal, op, goal_stack)
    dbg_indent(:gps, goal_stack.length, "Consider: %p", op.action)

    state2 = achieve_all(state, op.preconds, [goal] + goal_stack)

    unless state2.empty?
      dbg_indent(:gps, goal_stack.length, "Action: %p", op.action)
      (state2 - op.del_list) + op.add_list
    end
  end
end
