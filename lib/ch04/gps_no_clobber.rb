require 'gps'

class Array
  def subset_of?(other)
    (self - other) == []
  end
end

class GPS
  def solve(*goals)
    achieve_all goals
  end
  
  def apply(op)
    if achieve_all(op.preconds)
      puts "Executing #{op.action}"
      @state -= op.del_list
      @state += op.add_list
      return true
    end
    false
  end
  
  def achieve_all(goals)
    goals.all? do |goal|
      achieve goal
    end && goals.subset_of?(@state)
  end
end
