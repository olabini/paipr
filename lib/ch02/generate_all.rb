require 'rule_based'

def generate_all(phrase)
  case phrase
  when []
    [[]]
  when Array
    combine_all(generate_all(phrase[0]),
                generate_all(phrase[1..-1]))
  when Symbol
    rewrites(phrase).inject([]) { |sum, elt|  sum + generate_all(elt) }
  else
    [[phrase]]
  end
end

def combine_all(xlist, ylist)
  ylist.inject([]) do |sum, y|
    sum + xlist.map { |x| x+y }
  end
end
