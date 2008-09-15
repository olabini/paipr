require 'pat3'

class Pattern
  # Match pattern against input in the context of the bindings
  def match(input, variables = {}, pattern = @pattern)
    case
    when variables.nil?
      nil
    when variable?(pattern)
      match_variable(pattern, input, variables)
    when pattern == input
      variables
    when segment_pattern?(pattern)
      match_segment(pattern, input, variables)
    when pattern.is_a?(Array) && input.is_a?(Array)
      match(input[1..-1], 
            match(input[0], variables, pattern[0]), 
            pattern[1..-1])
    else
      nil
    end
  end
  
  def match_variable(p, i, bindings)
    (bindings[p].nil? && bindings.merge(p => i)) ||
      (bindings[p] == i && bindings)
  end

  def segment_pattern?(p)
    p.is_a?(Array) && p[0][0] == ?*
  end

  def match_segment(pattern, input, bindings, start = 0)
    var = "?#{pattern[0][1..-1]}"
    pat = pattern[1..-1]
    if pat.nil? || pat.empty?
      match_variable(var, input, bindings)
    else
      pos = input[start..-1].index(pat[0])
      return nil unless pos
      b2 = match(input[(start+pos)..-1], bindings, pat)
      if b2.nil?
        match_segment(pattern, input, bindings, start+1)
      else
        match_variable(var, input[0...(start+pos)], b2)
      end
    end
  end
end
