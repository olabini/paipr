require 'enumerator'

class Pattern
  def initialize(pattern)
    @pattern = pattern
  end
  
  # Does pattern match input? Any variable can match anything
  def match(input, variables = [], pattern = @pattern)
    pattern.enum_for(:zip, input).all? do |p, i|
      (p.is_a?(Array) && i.is_a?(Array) && match(i, variables, p)) ||
        (variable?(p) && (variables << [p, i])) ||
        p == i
    end && variables
  end
  
  def variable?(pattern)
    pattern.is_a?(String) && pattern[0] == ??
  end
end
