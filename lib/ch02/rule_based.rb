require 'common'

# A grammar for a trivial subset of English
$simple_grammar = { 
  :sentence => [[:noun_phrase, :verb_phrase]],
  :noun_phrase => [[:Article, :Noun]],
  :verb_phrase => [[:Verb, :noun_phrase]],
  :Article => %w(the a),
  :Noun => %w(man ball woman table),
  :Verb => %w(hit took saw liked)}

# The grammer used by generate. Initially this is $simple_grammar, but
# we can switch to other grammars
$grammar = $simple_grammar

def rewrites(category)
  $grammar[category]
end

def generate(phrase)
  case phrase
  when Array
    phrase.inject([]) { |sum, elt|  sum + generate(elt) }
  when Symbol
    generate(rewrites(phrase).random_elt)
  else
    [phrase]
  end
end
