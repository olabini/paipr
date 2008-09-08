require 'bigger_grammar'

def generate_tree(phrase)
  case phrase
  when Array
    phrase.map { |elt| generate_tree(elt) }
  when Symbol
    [phrase] + generate_tree(rewrites(phrase).random_elt)
  else
    [phrase]
  end
end
