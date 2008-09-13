require 'gps2'

class GPS2
  def action?(x)
    x == [:start] || (x.is_a?(Array) && x.first == :executing)
  end
  
  def solve(*goals)
    achieve_all([[:start]] + @state, goals, []).find_all do |state|
      action?(state)
    end
  end
end
