$:.unshift '../ch04'
require 'gps3'
require 'blocks'
require 'beam_search'


class GPS2
  def successors(state)
    applicable_ops(state).map do |op|
      state.select do |x|
        !op.del_list.include?(x)
      end + op.add_list
    end
  end

  def applicable_ops(state)
    @ops.select do |op|
      op.preconds.subset_of?(state)
    end
  end
  
  def search(goal, beam_width = 10)
    Search.beam([[:start]] + @state,
                proc { |n| successors(n) },
                proc { |state|
                  state.select { |s| action?(s) }.size +
                  goal.select  { |con| !state.include?(con) }.size
                },
                beam_width
                ) do |state|
      goal.subset_of?(state)
    end.select do |s|
      action?(s)
    end
  end
end

if __FILE__ == $0
  gps = GPS2.new([[:c, :on, :a], 
                  [:a, :on, :table],
                  [:b, :on, :table],
                  [:space, :on, :c], 
                  [:space, :on, :b], 
                  [:space, :on, :table]],
                 Blocks.make_ops([:a, :b, :c]))
  require 'pp'
  pp gps.search([[:a, :on, :b], [:b, :on, :c]])
end
