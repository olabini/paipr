class Pattern
  def initialize(pattern)
    @pattern = pattern
  end

  def match(input, bindings = {}, pattern = @pattern)
    case
    when !bindings
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

  def match_variable(px, i, bindings)
    (!bindings[px] && bindings.merge(px => i)) ||
      (bindings[px] == i && bindings)
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
    when !bindings
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
      if !new_bindings
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
    var = pattern[0][1]
    pat = pattern[1..-1]
    if !pat || pat.empty?
      match_variable(var, input, bindings)
    else
      pos = first_match_pos(pat[0], input, start)
      return nil unless pos

      b2 = match(input[pos..-1], 
                 match_variable(var, input[0...pos], bindings), 
                 pat)
      return b2 if b2
      segment_match(pattern, input, bindings, pos+1)
    end
  end
  
  def first_match_pos(pat1, input, start)
    input = [] unless input
    case
    when !pat1.is_a?(Array) && !variable?(pat1)
      (vv = input[start..-1].index(pat1)) && vv + start
    when start < input.length
      start
    else
      nil
    end
  end

  def segment_match_plus(pattern, input, bindings)
    segment_match(pattern, input, bindings, 1)
  end

  def segment_match_?(pattern, input, bindings)
    var = pattern[0][1]
    pat = pattern[1..-1]
    match(input, bindings, [var] + pat) ||
      match(input, bindings, pat)
  end

  def match_if(pattern, input, bindings)
    # Not implemented because of the current structure of the matching
    false
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
    "??"  => :segment_match_?,
    "?if" => :match_if
  }
end

require 'pat_read'
p Pattern.from_string("a (?* ?x) d").match(%w(a b c d))
p Pattern.from_string("a (?* ?x) (?* ?y) d").match(%w(a b c d))
p Pattern.from_string("a (?* ?x) (?* ?y) ?x ?y").match(['a', 'b', 'c', 'd', ['b', 'c'], ['d']])

Pattern.match_abbrev :"?x*", %w(?* ?x)
Pattern.match_abbrev :"?y*", %w(?* ?y)

p Pattern.from_string("a ?x* b")
