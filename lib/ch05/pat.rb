require 'enumerator'

class Pattern
  def initialize(pattern)
    @pattern = pattern
  end
  
  # Does pattern match input? Any variable can match anything
  def match(input, pattern = @pattern)
    pattern.enum_for(:zip, input).all? do |p, i|
      (p.is_a?(Array) && i.is_a?(Array) && match(i, p)) ||
        variable?(p) ||
        p == i
    end
  end
  
  def variable?(pattern)
    pattern.is_a?(String) && pattern[0] == ??
  end
end
