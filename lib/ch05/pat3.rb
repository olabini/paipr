require 'pat2'

class Pattern
  # Match pattern against input in the context of the bindings
  def match(input, variables = {}, pattern = @pattern)
    pattern.enum_for(:zip, input).all? do |p, i|
      match_recurse(p, i, variables) ||
        match_variable(p, i, variables) ||
        p == i
    end && variables
  end

  def match_recurse(p, i, bindings)
    p.is_a?(Array) && i.is_a?(Array) && match(i, bindings, p)
  end
  
  def match_variable(p, i, bindings)
    variable?(p) &&
      ((bindings[p].nil? && (bindings[p] = i)) || 
       bindings[p] == i)
  end
end
