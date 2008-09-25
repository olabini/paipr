class Pattern
  def initialize(pattern)
    @pattern = pattern
  end

  def match(input, bindings = {}, pattern = @pattern)
    p [:match, input, bindings, pattern]
    case
    when bindings.nil?
      nil
    when variable?(pattern)
      match_variable(pattern, input, bindings)
    when pattern == input
      bindings
    when segment_pattern?(pattern)
      segment_matcher(pattern, input, bindings)
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

  def segment_pattern?(pattern)
    pattern.is_a?(Array) && 
      pattern.first.is_a?(Array) &&
      SEGMENT_MATCH[pattern.first.first]
  end

  def single_pattern?(pattern)
    pattern.is_a?(Array) && 
      SINGLE_MATCH[pattern.first]
  end

  def segment_matcher(pattern, input, bindings)
    self.send(SEGMENT_MATCH[pattern.first.first], 
              pattern, 
              input, 
              bindings)
  end

  def single_matcher(pattern, input, bindings)
    self.send(SINGLE_MATCH[pattern.first], 
              pattern[1..-1], 
              input, 
              bindings)
  end

  def match_is(var_and_pred, input, bindings)
    var, pred = var_and_pred
    new_bindings = match(var, input, bindings)
    if !new_bindings || !self.send(pred, input)
      nil
    else
      new_bindings
    end
  end

  def match_and(patterns, input, bindings)
    case 
    when bindings.nil?
      nil
    when patterns.empty?
      bindings
    else
      match_and(patterns[1..-1], 
                input, 
                match(patterns[0], 
                      input, 
                      bindings))
    end
  end
  
  def match_or(patterns, input, bindings)
    if patterns.empty?
      nil
    else
      new_bindings = match(patterns[0], input, bindings)
      if new_bindings.nil?
        match_or(patterns[1..-1], input, bindings)
      else
        new_bindings
      end
    end
  end
  
  def match_not(patterns, input, bindings)
    if match_or(patterns,input,bindings)
      nil
    else
      bindings
    end
  end
  
  def segment_match(pattern, input, bindings, start = 0)
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

require 'pat_read'
p Pattern.from_string("a (?* ?x) d")
p Pattern.from_string("a (?* ?x) d").match(%w(a b c d))
