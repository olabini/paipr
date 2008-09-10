class GPS
  Op = Struct.new(:action, :preconds, :add_list, :del_list)

  def initialize(state, ops)
    @state = state
    @ops = ops
  end
  
  # General Problem Solver main interface: achieve all goals using
  # defined operations
  def solve(*goals)
    goals.all? do |goal|
      achieve goal
    end
  end
  
  # A goal is achieved if it already holds, or if there is an
  # appropriate op for it that is applicable
  def achieve(goal)
    @state.include?(goal) ||
      (@ops.find_all do |op| 
         appropriate?(goal, op) 
       end.any? do |op| 
         apply(op) 
       end)
  end

  # An op is appropriate to a goal if it is in its add list
  def appropriate?(goal, op)
    op.add_list.include?(goal)
  end
  
  # Print a message and update state if op is applicable
  def apply(op)
    if op.preconds.all? { |cond| achieve(cond) }
      puts "Executing #{op.action}"
      @state -= op.del_list
      @state += op.add_list
      return true
    end
    false
  end

  SCHOOL_OPS = [
                Op.new(:drive_son_to_school, 
                       [:son_at_home, :car_works],
                       [:son_at_school],
                       [:son_at_home]),
                Op.new(:shop_installs_battery, 
                       [:car_needs_battery, :shop_knows_problem, :shop_has_money],
                       [:car_works],
                       []),
                Op.new(:tell_shop_problem, 
                       [:in_communication_with_shop],
                       [:shop_knows_problem],
                       []),
                Op.new(:telephone_shop, 
                       [:know_phone_number],
                       [:in_communication_with_shop],
                       []),
                Op.new(:look_up_number, 
                       [:have_phone_book],
                       [:know_phone_number],
                       []),
                Op.new(:give_shop_money, 
                       [:have_money],
                       [:shop_has_money],
                       [:have_money])
               ]
end

