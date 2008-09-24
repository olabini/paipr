class Pattern
  def initialize(pattern)
    @pattern = pattern
  end

  def match(input, bindings = {}, pattern = @pattern)
    case
    when bindings.nil?
      nil
    when variable?(pattern)
      match_variable(pattern, input, bindings)
    when pattern == input
      bindings
    when segment_pattern?(pattern)
      match_segment(pattern, input, bindings)
    when single_pattern?(pattern)
      single_matcher(pattern, input, bindings)
    when pattern.is_a?(Array) && input.is_a?(Array)
      match(input[1..-1], 
            match(input[0], bindings, pattern[0]), 
            pattern[1..-1])
    else
      nil
    end
  end

  def variable?(pattern)
    pattern.is_a?(String) && pattern[0] == ??
  end

  def match_variable(p, i, bindings)
    (bindings[p].nil? && bindings.merge(p => i)) ||
      (bindings[p] == i && bindings)
  end
  
  SINGLE_MATCH = {
    "?is"  => :match_is,
    "?or"  => :match_or,
    "?and" => :match_and,
    "?not" => :match_not
  }

  SEGMENT_MATCH = { 
    "?*"  => :segment_match,
    "?+"  => :segment_match_plus,
    "??"  => :segment_match?,
    "?if" => :match_if
  }
end
