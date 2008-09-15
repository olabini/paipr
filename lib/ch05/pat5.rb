require 'pat4'

class Pattern
  def match_segment(pattern, input, bindings, start = 0)
    var = "?#{pattern[0][1..-1]}"
    pat = pattern[1..-1]
    if pat.nil? || pat.empty?
      match_variable(var, input, bindings)
    else
      pos = input[start..-1].index(pat[0])
      return nil unless pos

      b2 = match(input[(start+pos)..-1], 
                 match_variable(var, input[0...(start+pos)], bindings), 
                 pat)

      if !b2
        match_segment(pattern, input, bindings, start+1)
      else
        b2
      end
    end
  end
end
